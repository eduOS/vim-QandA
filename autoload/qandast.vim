if !has("python") || exists("g:qandast_pyloaded")
  finish
endif

python <<EOF
import vim

def bwrite(s):
    b = vim.current.buffer
    s = s.replace('<92>',"'").replace('\xc3\x82\xc2\x92',"'")
    if not s.strip() and not b[-1].strip() and not b[-2].strip():
        return

    if not b[0]:
        b[0] = s
    else:
        b.append(s)

# press N or P to start one new question or go back to the previous one
    # press n or p to draw or erase one line: one line per line

# start with a list containing short number, date and topic by pressing :qanda creating a new buffer and saving the current one if any
    # enter one episode by pressing enter, then a new buffer appears listing the panellists' info and greetings. the list disappear
    # by a toggle shortcut the list is available as a vertical buffer <C-N>

# write all transcripts 
import MySQLdb as mdb

def connectDB():
    try:
        con = mdb.connect('localhost','root',"104064", 'QandA')
    except:
        print 'database not exists'
    return con

def write_list():
    con = connectDB()
    cur = con.cursor()
    sql = 'select distinct epiShortNumber, hentryDate, bookmark from hentry order by hentryDate desc limit 10'
    cur.execute(sql)
    epiList = cur.fetchall()
    for epi in epiList:
        bwrite(epi[0] + ' ' + epi[1] + ' ' + epi[2] + ' ')
    cur.close()
    con.close()

def extract_tran():
    con = connectDB()
    cur = con.cursor()
    cur_line = vim.eval("getline(\".\")")
    vim.command("normal ggdG")
    vim.command("set cursorline")
    shnum = cur_line.split()[0]
    vim.command("let t:shnum="+str(shnum))
    sql = 'select questionNumber, question, answers from qanda where epiShortNumber = %s'
    cur.execute(sql, (shnum,))
    trans = cur.fetchall()
    for tran in trans:
        bwrite(tran[0])
        bwrite(' ')
        bwrite(tran[1])
        bwrite(' ')
        for line in tran[2].split('\n'):
            bwrite(line)
            bwrite(' ')
        bwrite(' ')
    cur.close()
    con.close()
        
def query_panel():
    con = connectDB()
    cur = con.cursor()
    shnum = vim.eval("t:shnum")
    sql = 'select distinct panelName, panelProfile from panellist where panelName in (select panelName from henPan where epiShortNumber = %s)'
    cur.execute(sql,(shnum))
    panelList = cur.fetchall()
    for pan in panelList:
        bwrite(pan[0]) 
        bwrite('  ') 
        for line in pan[1].split('\n'):
            bwrite(line) 
        bwrite('-----------------------')
        bwrite('  ')
    cur.close()
    con.close()

def query_panellist():
    con = connectDB()
    cur = con.cursor()
    cur_line = vim.eval("getline(\".\")")
    pname = cur_line.split(':')[0]
    #sql = 'select panelProfile from panellist where '
    cur.close()
    con.close()
EOF

function! s:extractTran()
    python extract_tran()
endfunction

function! qandast#init()
    let g:qandast_pyloaded = 1
    file _qanda_
    set filetype=qanda
    python write_list()
    nnoremap <buffer> <CR> :call <SID>extractTran()<cr>
    nnoremap <buffer> q :q!<cr>
endfunction

function! s:showpnInit()
    setlocal bufhidden=delete noswapfile
    nnoremap <buffer> <silent> q :q!<CR>
endfunction

function! qandast#showPanelist()
    windo if expand("%")=="_qandapnl_" |q!|endif
    windo if expand("%")=="_qandapn_" |25sp _qandapnl_|else|50vsp _qandapnl_|endif
    call <SID>showpnInit()
    python query_panellist()
endfunction

function! qandast#showPanel()
    windo if expand("%")=="_qandapn_" |q!|endif
    windo if expand("%")=="_qandapnl_" |25sp _qandapn_|else|50vsp _qandapn_|endif
    call <SID>showpnInit()
    python query_panel()
endfunction
