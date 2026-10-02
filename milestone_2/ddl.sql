CREATE DATABASE oficina_carro;
USE oficina_carro;

CREATE TABLE pessoa (
    pess_id INT NOT NULL AUTO_INCREMENT,
    pess_nome VARCHAR(50) NOT NULL,
    pess_cpf VARCHAR(11) NOT NULL,
    pess_dt_nascimento DATE NOT NULL,
    pess_telefone VARCHAR(11) NOT NULL,
    pess_email VARCHAR(100) NOT NULL,
    pess_cep VARCHAR(8),
    pess_en_logradouro VARCHAR(45) NOT NULL,
    pess_en_numero VARCHAR(6) NOT NULL,
    pess_en_bairro VARCHAR(45) NOT NULL,
    pess_en_complemento VARCHAR(100) NOT NULL,
    pess_observacoes VARCHAR(500),
    
    CONSTRAINT pk_pessoa PRIMARY KEY (pess_id)
);

CREATE TABLE funcao (
	funo_id INT NOT NULL AUTO_INCREMENT,
    funo_funcao VARCHAR(30) NOT NULL,
    
    CONSTRAINT pk_funcao PRIMARY KEY (funo_id)
);

-- INSERT INTO funcao (funo_funcao) VALUES ("Mecânico"),("Secretária"),("Estoquista");

CREATE TABLE funcionario (
	func_login VARCHAR(30),
	func_senha VARCHAR(100),
	func_hr_trabalho_entrada TIME,
    func_hr_trabalho_saida TIME,
    funo_id VARCHAR(45),
    pess_id INT NOT NULL,
    
    CONSTRAINT pk_funcionario PRIMARY KEY (pess_id, funo_id, func_login),
    
    CONSTRAINT fk__func_funcao 
		FOREIGN KEY (funo_id) 
        REFERENCES funcao (funo_id),
    CONSTRAINT fk_func_pessoa
		FOREIGN KEY (pess_id)
        REFERENCES pessoa (pess_id)
);

CREATE TABLE carro_marca (
	cama_id INT NOT NULL AUTO_INCREMENT,
    cama_marca VARCHAR(30) NOT NULL,
    
    CONSTRAINT pk_marca PRIMARY KEY (cama_id)
);

CREATE TABLE carro_modelo (
	camo INT NOT NULL AUTO_INCREMENT,
    camo_modelo VARCHAR(100),
    cama_id INT NOT NULL,
    
    CONSTRAINT pk_modelo PRIMARY KEY (mode_id),
    
    CONSTRAINT fk_camo_marca FOREIGN KEY (cama_id) REFERENCES carro_marca(cama_id)
);

CREATE TABLE veiculo (
    veic_id INT NOT NULL AUTO_INCREMENT,
    veic_placa VARCHAR(7) NOT NULL,
    veic_cor VARCHAR(20) NOT NULL,
    pess_id INT NOT NULL,
    veic_ano YEAR NULL,
    camo_id INT NOT NULL,
    
    CONSTRAINT pk_veiculo PRIMARY KEY (veic_id),
    
    CONSTRAINT fk_camo_modelo FOREIGN KEY (camo_id) REFERENCES carro_modelo(camo_id)
);

/*
CREATE TABLE servico (
    serv_id INT NOT NULL AUTO_INCREMENT,
    serv_servico VARCHAR(45) NOT NULL,
    serv_descricao VARCHAR(255) NULL,
    serv_preco DECIMAL(5 , 2 ) NOT NULL,
    
    CONSTRAINT pk_servico PRIMARY KEY (serv_id)
);
*/

/*
CREATE TABLE agendamento (
    agen_id INT NOT NULL AUTO_INCREMENT,
    agen_data VARCHAR(45) NOT NULL,
    meca_id INT NOT NULL,
    
    CONSTRAINT pk_agendamento PRIMARY KEY (agen_id),
    
    CONSTRAINT fk_agen_mecanico FOREIGN KEY (meca_id)
        REFERENCES pessoa (pess_id)
);
*/

CREATE TABLE distribuidora (
    dist_id INT NOT NULL AUTO_INCREMENT,
    dist_cnpj VARCHAR(14) NOT NULL,
    dist_telefone VARCHAR(11) NOT NULL,
    dist_email VARCHAR(100) NOT NULL,
    dist_cep VARCHAR(8),
    dist_en_logradouro VARCHAR(100) NOT NULL,
    dist_en_numero VARCHAR(6) NOT NULL,
    dist_en_bairro VARCHAR(100) NOT NULL,
    dist_en_complemento VARCHAR(100) NOT NULL,
    dist_observacoes VARCHAR(500),
    
    CONSTRAINT pk_distribuidora PRIMARY KEY (dist_id)
);

CREATE TABLE peca (
    peca_id INT NOT NULL AUTO_INCREMENT,
    peca_nome VARCHAR(30) NOT NULL,
    peca_descricao VARCHAR(255) NOT NULL,
    peca_estoque INT NOT NULL,
    peca_preco DECIMAL(5, 2) NOT NULL,
    carr_modelo INT NOT NULL,
    
    CONSTRAINT pk_peca PRIMARY KEY (peca_id),
    
    CONSTRAINT fk_peca_carro_modelo FOREIGN KEY (carr_modelo) REFERENCES carro_modelo(mode_id)
);

CREATE TABLE peca_distribuidora (
    peca_id INT NOT NULL,
    dist_id INT NOT NULL,
    pedi_quantidade INT NOT NULL,
    
    CONSTRAINT pk_pedi PRIMARY KEY (peca_id , dist_id , pedi_quantidade),
    
    CONSTRAINT fk_pedi_peca FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id),
    CONSTRAINT fk_pedi_distribuidora FOREIGN KEY (dist_id)
        REFERENCES distribuidora (dist_id)
);

CREATE TABLE orcamento (
	orca_id INT NOT NULL AUTO_INCREMENT,
    orca_valor INT NOT NULL DEFAULT 0,
    orca_formato VARCHAR(20) NOT NULL,
    veic_id INT NOT NULL, # O cliente ja esta vinculado ao veiculo
    orca_quilometragem INT NOT NULL,
    
    CONSTRAINT pk_orcamento PRIMARY KEY (orca_id),
    
    CONSTRAINT fk_orcamento_veiculo FOREIGN KEY (veic_id) 
		REFERENCES veiculo(veic_id)
);

CREATE TABLE ordem_servico (
    os_id INT NOT NULL AUTO_INCREMENT,
    os_detalhes VARCHAR(45) NULL,
    os_box TINYINT UNSIGNED NOT NULL,
    os_inicio TIME NOT NULL,
    os_status VARCHAR(20) NOT NULL,
    serv_id INT NOT NULL,
    agen_id INT NOT NULL,
    orca_id INT NOT NULL,
    meca_id INT NOT NULL, # Mecânico é uma especializacao da tabela 'pessoa'
    
    CONSTRAINT pk_ordem_servico PRIMARY KEY (os_id),
    
    CONSTRAINT fk_os_servico FOREIGN KEY (serv_id)
        REFERENCES servico (serv_id),
    CONSTRAINT fk_os_agendamento FOREIGN KEY (agen_id)
        REFERENCES agendamento (agen_id),
	CONSTRAINT fk_os_orcamento FOREIGN KEY (orca_id)
		REFERENCES orcamento(orca_id),
	CONSTRAINT fk_os_mecanico FOREIGN KEY (meca_id)
		REFERENCES pessoa(pess_id)
);

CREATE TABLE ordem_servico_peca (
    os_id INT NOT NULL,
    peca_id INT NOT NULL,
    ospe_qt_peca INT NOT NULL,
    
    CONSTRAINT fk_ospe_os FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id),
    CONSTRAINT fk_ospe_peca FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id)
);

CREATE TABLE pagamento (
    paga_metodo VARCHAR(45) NOT NULL,
    paga_nota_fiscal VARCHAR(44) NOT NULL,
    os_id INT NOT NULL,
    
    CONSTRAINT pk_pagamento PRIMARY KEY (paga_nota_fiscal, os_id),
    
    CONSTRAINT fk_paga_os FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id)
);

/*
CREATE TABLE pessoa_veiculo (
    pess_id INT NOT NULL,
    veic_id INT NOT NULL,
    
    CONSTRAINT pk_peve PRIMARY KEY (pess_id , veic_id),
    
    CONSTRAINT fk_peve_veiculo FOREIGN KEY (veic_id)
        REFERENCES veiculo (veic_id),
    CONSTRAINT fk_peve_pessoa FOREIGN KEY (pess_id)
        REFERENCES pessoa (pess_id)
);
*/