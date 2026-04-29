const { Document, Packer, Paragraph } = require("docx");
const fs = require("fs");

const doc = new Document({
    sections: [
        {
            children: [
                new Paragraph("Hello, this is your DOCX file!"),
            ],
        },
    ],
});

Packer.toBuffer(doc).then((buffer) => {
    fs.writeFileSync("output.docx", buffer);
});