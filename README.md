# terraform-http-until

HTTP GETs until code and/or body matches.

## usage

    module "example-com-is-up" {
      source  = "matti/until/http"

      uri = "http://www.example.com"
      code_must_equal   = ""  # must be set unless body_must_include
      body_must_include = ""  # must be set unless code_must_equal

      max_tries         = 60  # optional
      interval          = 1   # optional
      depends_id        = "${optional.resource.id}"
    }

## test

    $ terraform apply -var uri=https://example.com -var code_must_equal="200" -var body_must_include="Example Domain"
      data.external.http: Refreshing state...

      Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

      Outputs:

      result = {
        body = <!doctype html>
          ...
        body_did_satisfy = 1
        code = 200
        code_did_satisfy = 1
        tries = 1
      }
