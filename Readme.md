# Playing with Terraform

Using the official docs and online guides to play with the awesome sauce that is Terraform.

To cleanup all the labs in one shot from the repo root...

    for D in */; do (cd $D && terraform destroy -force); done

## 001 - VM

A simple starter that creates a VM with SSH credentials from the environment that apply is ran.

    cd 001 
    terraform apply

## 002 - HTTP Function

Creates an archive and storage bucket. Uploads archive to the bucket.  Creates an http function using the JS from the bucket.  [Tutorial source](https://opencredo.com/blogs/google-cloudfunctions-with-terraform/).

    cd 002
    terraform apply
    curl [output.url]

## 003 - Simple Apache Server

A simple server that uses a startup script with variables passed into it.

    cd --3
    terraform apply
    curl [output ip]