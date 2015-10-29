

DIR=`mktemp -d`

pushd $DIR
wget https://www.elastic.co/guide/en/kibana/3.0/snippets/shakespeare.json
wget https://github.com/bly2k/files/blob/master/accounts.zip?raw=true -O accounts.zip
wget https://download.elastic.co/demos/kibana/gettingstarted/logs.jsonl.gz
curl -XPUT http://localhost:9200/shakespeare -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "string", "index" : "not_analyzed" },
    "play_name" : {"type": "string", "index" : "not_analyzed" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}';
unzip accounts.zip
gzip -d logs.jsonl.gz
curl -XPOST 'localhost:9200/bank/_bulk?pretty' --data-binary @accounts.json
curl -XPOST 'localhost:9200/shakespeare/_bulk?pretty' --data-binary @shakespeare.json
curl -XPOST 'localhost:9200/_bulk?pretty' --data-binary @logs.jsonl

