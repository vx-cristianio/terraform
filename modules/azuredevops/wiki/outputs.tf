output "wiki_id" {  //we output either existing wiki Id or Id of newly created Wiki
  value = coalesce(try(jsondecode(data.terracurl_request.wiki.response).id, null), try(jsondecode(terracurl_request.wiki.response).id, null))

}