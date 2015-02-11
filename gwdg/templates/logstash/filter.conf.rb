filter {
    grok {
        type => "extra"
        pattern => "(?<s3date>%{DATE_EU} %{TIME}) %{WORD:cfedge} %{BASE10NUM:size} %{IP:client} %{WORD:method} %{UNIXPATH:request} %{BASE10NUM:response} %{GREEDYDATA:useragent} %{WORD:cfhitmiss}"
    }
    date {
        type => "extra"
        match => [ "s3date", "yyyy-MM-dd HH:mm:ss" ]
    }
}
