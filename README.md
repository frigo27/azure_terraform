# azure_terraform


atividade4-unyleya

Atividade contempla:

    Provisionar instância Windows Server 2019 na AWS via Terraform;
    Configurar via ansible IIS na instância criada, utilizando conexão WinRM.


#terraform init

#terraform apply

Assim será provisionada instância.

-No diretório playbook_ansible:

#ansible-playbook play.yml -i inventario

Habilita WinRM sobre https.

#ansible-playbook iis.yml -i inventario

Instala o servidor web IIS e cria um index.html personalizado.
