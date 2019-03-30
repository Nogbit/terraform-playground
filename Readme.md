# Playing with Terraform

Using the official docs and online guides to play with the awesome sauce that is Terraform.

To cleanup all the labs in one shot from the repo root...

    for D in */; do (cd $D && terraform destroy -force); done

## 001 - VM

A simple starter that creates a VM with SSH credentials from the environment that apply is ran.

    cd 001 
    terraform apply

## 002 - HTTP Function

Creates an archive and storage bucket. Uploads archive to the bucket.  Creates an http function using the JS from the bucket.

    terraform apply
    curl [output.url]