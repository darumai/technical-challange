# PDF Bonanza
Main requirements for running the project:
- Ruby (3.0.0)
- Rails (7.1.3.2)
- PostgreSQL
## Added gems
- [google-cloud-storage](https://github.com/googleapis/google-cloud-ruby/tree/main/google-cloud-storage "google-cloud-storage")
- [dotenv-rails](https://github.com/bkeepers/dotenv "dotenv-rails")
- [rspec-rails](https://github.com/rspec/rspec-rails "rspec-rails")
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails "factory_bot_rails")
## Specific Dependencies
- [pandoc](https://pandoc.org/ "pandoc")
- [weasyprint](https://weasyprint.org/ "weasyprint")

If you are using Ubuntu, all you need to do is to run the following command:
```
sudo apt-get install pandoc weasyprint
```
The famous [wkhtmltopdf](https://github.com/wkhtmltopdf/wkhtmltopdf "wkhtmltopdf") gem is now deprecated (last Ubuntu version with support was 22.04 and the current stable version of Debian is not supported), so I went with a more native solution instead, that being [Pandoc](https://pandoc.org/ "Pandoc") for it's reliability and performance.
The application has been coded in such a way that replacing the software responsible for rendering PDFs is as simple as it gets, as the document generation logic is completely agnostic to it. Adding [Pupeteer](https://pptr.dev/ "Pupeteer") as the main or fallback renderer is a possibility, for example.

##Installing and running the project
```
$ bundle install
$ rake db:create
$ rake db:migrate
$ rails s
```

The API has two endpoints:

- GET /api/v1/documents/list
- POST/PUT /api/v1/documents/create

The first one (documents/list) shows all the previously created documents, their information and
metadata, as follows:
```javascript
// Example response of the GET /api/v1/documents/list request
[
  {
    "uuid": "2b2ab03a-8b81-47c1-9af3-3b3c8d695f71",
    "pdf_url": "presigned_url or local file path",
    "description": "Example description 1",
    "document_data": { // arbitrary data coming from the user
      "customer_name": "Tomás",
      "contract_value": "R$ 1.990,90",
      // ...
    },
    "created_at": "2012-04-23T18:25:43.511Z"
  },
    {
    "uuid": "d3b75481-3f8e-4a23-9c2e-738abf8e998b",
    "pdf_url": "presigned_url or local file path",
    "description": "Example description 2",
    "document_data": { // arbitrary data coming from the user
      "customer_name": "Haroldo",
      "contract_value": "R$ 10.990,90",
      // ...
    },
    "created_at": "2012-04-23T18:25:43.511Z"
  },
  // ...
]
```

The other endpoint allows the creation of PDFs from HTML fragments with placeholders to substitute
the data from the `document_data` entry above. The request and the response are as demonstrated
below:

```javascript
// Example request to the POST/PUT /api/v1/documents/create endpoint
{
  "description": "Example description 2",
  "document_data": { // arbitrary data coming from the user
    "customer_name": "Haroldo",
    "contract_value": "R$ 10.990,90",
    // ...
  },
  "template": "<style>body { color: red; }</style><div>{{customer_name}} {{content}}</div>"
}
```

```javascript
// Example response of the POST/PUT /api/v1/documents/create endpoint
{
  "uuid": "10a32fae-1c61-4b2f-b5c7-4de80f4d6f1d",
  "pdf_url": "presigned_url or local file path",
  "description": "Example description 2",
  "document_data": { // arbitrary data coming from the user
    "customer_name": "Haroldo",
    "contract_value": "R$ 10.990,90"
  },
  "created_at": "2012-04-23T18:25:43.511Z"
}
```
##Tests
To run the test suite, execute the following command within the app's root directory:
```
bundle exec rspec 
```
