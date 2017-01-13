require 'uri'
xml.instruct! :xml, :version => "1.0", :standalone => "no"
xml.filelist do

  @filelist.each do |f|
    if f[:url]
      xml.file do
        /\d+\/(.+)\Z/ =~ f[:url]
        s = $1
        s_unescape = URI.unescape(s)
        xml.name("[#{@order.contract_number}]" + s_unescape)
        xml.url("http://soweb.sow.office.bbtower.co.jp" + f[:url])
        xml.last_modified(f[:last_modified])
      end
    end
  end
end
