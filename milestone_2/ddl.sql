CREATE DATABASE oficina_carro;
USE oficina_carro;

CREATE TABLE pessoa (
    pess_id INT NOT NULL AUTO_INCREMENT,
    pess_nome VARCHAR(50) NOT NULL,
    pess_cpf VARCHAR(11) NOT NULL,
    pess_dt_nascimento DATE NOT NULL,
    pess_telefone VARCHAR(11) NOT NULL,
    pess_email VARCHAR(100) NOT NULL,
    pess_ct_preferencial VARCHAR(100) NOT NULL, # Contato preferencial
    pess_cep VARCHAR(8),
    pess_en_logradouro VARCHAR(45) NOT NULL,
    pess_en_numero VARCHAR(6) NOT NULL,
    pess_en_bairro VARCHAR(45) NOT NULL,
    pess_en_complemento VARCHAR(100) NOT NULL,
    pess_observacoes VARCHAR(500),
    PESS_CRIADO_EM DATETIME NOT NULL,
    PESS_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_pessoa_email (pess_email),
    UNIQUE KEY uk_pessoa_telefone (pess_telefone),
    
    CONSTRAINT pk_pessoa PRIMARY KEY (pess_id)
);

CREATE TABLE funcao (
	funo_id INT NOT NULL AUTO_INCREMENT,
    funo_funcao VARCHAR(30) NOT NULL,
    FUNO_CRIADO_EM DATETIME NOT NULL,
    FUNO_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_funcao_funcao (funo_funcao),
    
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
    FUNC_CRIADO_EM DATETIME NOT NULL,
    FUNC_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_funcionario_login (func_login),
    
    CONSTRAINT pk_funcionario PRIMARY KEY (pess_id, funo_id, func_login),
    
    CONSTRAINT fk__func_funcao 
		FOREIGN KEY (funo_id) 
        REFERENCES funcao (funo_id),
    CONSTRAINT fk_func_pessoa
		FOREIGN KEY (pess_id)
        REFERENCES pessoa (pess_id)
);

CREATE INDEX ix_pess_funcionario ON funcionario (pess_id);
CREATE INDEX ix_funcao_funcionario ON funcionario (funo_id);

CREATE TABLE carro_marca (
	cama_id INT NOT NULL AUTO_INCREMENT,
    cama_marca VARCHAR(30) NOT NULL,
    CAMA_CRIADO_EM DATETIME NOT NULL,
    CAMA_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_cama_marca (cama_marca),
    
    CONSTRAINT pk_marca PRIMARY KEY (cama_id)
);

CREATE INDEX ix_cama_01 ON carro_marca (cama_id, cama_marca);

CREATE TABLE carro_modelo (
	camo_id INT NOT NULL AUTO_INCREMENT,
    camo_modelo VARCHAR(100),
    cama_id INT NOT NULL,
    CAMA_CRIADO_EM DATETIME NOT NULL,
    CAMA_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_camo_modelo (camo_modelo),
    
    CONSTRAINT pk_modelo PRIMARY KEY (camo_id),
    
    CONSTRAINT fk_camo_marca 
		FOREIGN KEY (cama_id) 
        REFERENCES carro_marca (cama_id)
);

CREATE INDEX ix_camo_01 ON carro_modelo (camo_id, camo_modelo);

CREATE INDEX ix_cama_camo ON carro_modelo (cama_id);

CREATE TABLE veiculo (
    veic_id INT NOT NULL AUTO_INCREMENT,
    veic_placa VARCHAR(7) NOT NULL,
    veic_cor VARCHAR(20) NOT NULL,
    veic_ano YEAR NULL,
    pess_id INT NOT NULL,
    camo_id INT NOT NULL,
    VEIC_CRIADO_EM DATETIME NOT NULL,
    VEIC_ATUALIZADO_EM DATETIME NOT NULL,
    
    CONSTRAINT pk_veiculo PRIMARY KEY (veic_id),
    
    CONSTRAINT fk_camo_modelo 
		FOREIGN KEY (camo_id) 
        REFERENCES carro_modelo (camo_id)
);

CREATE INDEX ix_camo_veiculo ON veiculo (camo_id);

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
    DIST_CRIADO_EM DATETIME NOT NULL,
    DIST_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_distribuidora_cnpj (dist_cnpj),
    UNIQUE KEY uk_distribuidora_telefone (dist_telefone),
    UNIQUE KEY uk_distribuidora_email (dist_email),
    
    CONSTRAINT pk_distribuidora PRIMARY KEY (dist_id)
);

CREATE TABLE peca (
    peca_id INT NOT NULL AUTO_INCREMENT,
    peca_nome VARCHAR(30) NOT NULL,
    peca_categoria VARCHAR(50) NOT NULL,
    peca_descricao VARCHAR(255) NOT NULL,
    peca_estoque INT NOT NULL,
    peca_preco DECIMAL(5, 2) NOT NULL,
    carr_modelo INT NOT NULL,
    PECA_CRIADO_EM DATETIME NOT NULL,
    PECA_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_peca_nome (peca_nome),
    
    CONSTRAINT pk_peca PRIMARY KEY (peca_id),
    
    CONSTRAINT fk_peca_carro_modelo 
		FOREIGN KEY (carr_modelo)
        REFERENCES carro_modelo(camo_id)
);

CREATE INDEX ix_cate_peca ON peca (peca_categoria);
CREATE INDEX ix_esto_peca ON peca (peca_estoque);

CREATE TABLE peca_distribuidora (
    peca_id INT NOT NULL,
    dist_id INT NOT NULL,
    pedi_quantidade INT NOT NULL,
    PEDI_CRIADO_EM DATETIME NOT NULL,
    PEDI_ATUALIZADO_EM DATETIME NOT NULL,
    
    CONSTRAINT fk_pedi_peca 
		FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id),
    CONSTRAINT fk_pedi_distribuidora 
		FOREIGN KEY (dist_id)
        REFERENCES distribuidora (dist_id)
);

CREATE INDEX ix_dist_pedi ON peca_distribuidora (dist_id);

CREATE TABLE orcamento (
	orca_id INT NOT NULL AUTO_INCREMENT,
    orca_valor DECIMAL(10, 2) NOT NULL DEFAULT 0,
    orca_status VARCHAR(20) NOT NULL,
    orca_formato VARCHAR(20) NOT NULL,
    veic_id INT NOT NULL, # O cliente ja esta vinculado ao veiculo
    orca_quilometragem INT NOT NULL,
    ORCA_CRIADO_EM DATETIME NOT NULL,
    ORCA_ATUALIZADO_EM DATETIME NOT NULL,
    
    CONSTRAINT pk_orcamento PRIMARY KEY (orca_id),
    
    CONSTRAINT fk_orcamento_veiculo 
		FOREIGN KEY (veic_id) 
		REFERENCES veiculo(veic_id)
);

CREATE INDEX ix_orcamento_01 ON orcamento (orca_status);
CREATE INDEX ix_orcamento_02 ON orcamento (ORCA_CRIADO_EM);

CREATE TABLE ordem_servico (
    os_id INT NOT NULL AUTO_INCREMENT,
    os_detalhes VARCHAR(45) NULL,
    os_box TINYINT UNSIGNED NOT NULL,
    os_inicio TIME NOT NULL,
    os_status VARCHAR(20) NOT NULL,
    serv_id INT NOT NULL,
    agen_id INT NOT NULL,
    orca_id INT NOT NULL,
    meca_id INT NOT NULL, # Mecanico e uma especializacao da tabela 'pessoa'
    OS_CRIADO_EM DATETIME NOT NULL,
    OS_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_os_box (os_box), # O box nao pode estar ocupado
    
    CONSTRAINT pk_ordem_servico PRIMARY KEY (os_id),
    
    CONSTRAINT fk_os_servico 
		FOREIGN KEY (serv_id)
        REFERENCES servico (serv_id),
    CONSTRAINT fk_os_agendamento 
		FOREIGN KEY (agen_id)
        REFERENCES agendamento (agen_id),
	CONSTRAINT fk_os_orcamento 
		FOREIGN KEY (orca_id)
		REFERENCES orcamento(orca_id),
	CONSTRAINT fk_os_mecanico 
		FOREIGN KEY (meca_id)
		REFERENCES pessoa(pess_id)
);

CREATE INDEX ix_servico_os ON ordem_servico(serv_id);
CREATE INDEX ix_agendamento_os ON ordem_servico(agen_id);
CREATE INDEX ix_orcamento_os ON ordem_servico(orca_id);
CREATE INDEX ix_mecanico_os ON ordem_servico(meca_id);

CREATE TABLE ordem_servico_peca (
    os_id INT NOT NULL,
    peca_id INT NOT NULL,
    ospe_qt_peca INT NOT NULL,
    OSPE_CRIADO_EM DATETIME NOT NULL,
    OSPE_ATUALIZADO_EM DATETIME NOT NULL,
    
    CONSTRAINT pk_ospe PRIMARY KEY (os_id, peca_id),
    
    CONSTRAINT fk_ospe_os 
		FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id),
    CONSTRAINT fk_ospe_peca 
		FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id)
);

CREATE INDEX ix_os_ospe ON ordem_servico_peca(os_id);
CREATE INDEX ix_peca_ospe ON ordem_servico_peca(peca_id);

CREATE TABLE pagamento (
	paga_id INT NOT NULL AUTO_INCREMENT,
    paga_metodo VARCHAR(45) NOT NULL,
    paga_nota_fiscal VARCHAR(44) NOT NULL,
    paga_status VARCHAR(20) NOT NULL, # Pendente, Aprovado, ...
    paga_parcelado BOOL,
    os_id INT NOT NULL,
    PAGA_CRIADO_EM DATETIME NOT NULL,
    PAGA_ATUALIZADO_EM DATETIME NOT NULL,
    
    UNIQUE KEY uk_pagamento_nf (paga_nota_fiscal),
    UNIQUE KEY uk_pagamento_os (os_id),
    
    CONSTRAINT pk_pagamento PRIMARY KEY (paga_id),
    
    CONSTRAINT fk_pagamento_os 
		FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id)
);

CREATE INDEX ix_os_pagamento ON pagamento(os_id);

CREATE TABLE pagamento_parcelas (
	papa_parcelas TINYINT UNSIGNED NOT NULL,
    papa_parc_pagas TINYINT UNSIGNED NOT NULL,
    paga_id INT NOT NULL,
    PAPA_CRIADO_EM DATETIME NOT NULL,
    PAPA_ATUALIZADO_EM DATETIME NOT NULL,
    
    CONSTRAINT pk_pagamento_parcelas PRIMARY KEY (paga_id, papa_parcelas),
    
    CONSTRAINT fk_papa_pagamento 
		FOREIGN KEY (paga_id) 
        REFERENCES pagamento(paga_id)
);

CREATE INDEX ix_paga_papa ON pagamento_parcelas(paga_id);
