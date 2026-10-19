CREATE DATABASE oficina_carro;	
USE oficina_carro;

CREATE TABLE pessoa (
    pess_id INT NOT NULL AUTO_INCREMENT,
    pess_nome VARCHAR(50) NOT NULL,
    pess_cpf VARCHAR(11) NOT NULL,
    pess_dt_nascimento DATE NOT NULL,
    pess_telefone VARCHAR(11) NOT NULL,
    pess_email VARCHAR(100) NOT NULL,
    pess_ct_preferencial VARCHAR(100) NOT NULL, -- Contato preferencial
    pess_cep VARCHAR(8),
    pess_en_logradouro VARCHAR(45) NOT NULL,
    pess_en_numero VARCHAR(6) NOT NULL,
    pess_en_bairro VARCHAR(45) NOT NULL,
    pess_en_complemento VARCHAR(100),
    pess_observacoes VARCHAR(500),
    PESS_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PESS_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_pessoa_cpf (pess_cpf),
    UNIQUE KEY uk_pessoa_email (pess_email),
    CONSTRAINT pk_pessoa PRIMARY KEY (pess_id)
	
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE funcao (
    funo_id INT NOT NULL AUTO_INCREMENT,
    funo_funcao VARCHAR(30) NOT NULL,
    FUNO_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FUNO_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_funcao_funcao (funo_funcao),

    CONSTRAINT pk_funcao PRIMARY KEY (funo_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE carro_marca (
    cama_id INT NOT NULL AUTO_INCREMENT,
    cama_marca VARCHAR(30) NOT NULL,
    CAMA_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CAMA_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_cama_marca (cama_marca),

    CONSTRAINT pk_marca PRIMARY KEY (cama_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE distribuidora (
    dist_id INT NOT NULL AUTO_INCREMENT,
    dist_nome VARCHAR(100) NOT NULL,
    dist_cnpj VARCHAR(14) NOT NULL,
    dist_telefone VARCHAR(11) NOT NULL,
    dist_email VARCHAR(100) NOT NULL,
    dist_cep VARCHAR(8),
    dist_en_logradouro VARCHAR(100) NOT NULL,
    dist_en_numero VARCHAR(6) NOT NULL,
    dist_en_bairro VARCHAR(100) NOT NULL,
    dist_en_complemento VARCHAR(100),
    dist_observacoes VARCHAR(500),
    DIST_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DIST_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_distribuidora_cnpj (dist_cnpj),
    UNIQUE KEY uk_distribuidora_telefone (dist_telefone),
    UNIQUE KEY uk_distribuidora_email (dist_email),

    CONSTRAINT pk_distribuidora PRIMARY KEY (dist_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE box (
    box_id INT NOT NULL AUTO_INCREMENT,
    box_numero TINYINT UNSIGNED NOT NULL,
    BOX_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    BOX_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_box_numero (box_numero),

    CONSTRAINT pk_box PRIMARY KEY (box_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE servico (
    serv_id INT NOT NULL AUTO_INCREMENT,
    serv_nome VARCHAR(100) NOT NULL,
    serv_descricao VARCHAR(255),
    serv_valor DECIMAL(10, 2) NOT NULL,
    SERV_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    SERV_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_servico_nome (serv_nome),

    CONSTRAINT pk_servico PRIMARY KEY (serv_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE funcionario (
    pess_id INT NOT NULL,
    funo_id INT NOT NULL,
    func_login VARCHAR(30),
    func_senha VARCHAR(100),
    func_hr_trabalho_entrada TIME,
    func_hr_trabalho_saida TIME,
    FUNC_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FUNC_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_funcionario_login (func_login),

    CONSTRAINT pk_funcionario PRIMARY KEY (pess_id),

    CONSTRAINT ck_func_acesso
        CHECK ((func_login IS NULL) = (func_senha IS NULL)),

    CONSTRAINT fk_func_funcao
        FOREIGN KEY (funo_id)
        REFERENCES funcao (funo_id),
    CONSTRAINT fk_func_pessoa
        FOREIGN KEY (pess_id)
        REFERENCES pessoa (pess_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_funcao_funcionario ON funcionario (funo_id);

CREATE TABLE carro_modelo (
    camo_id INT NOT NULL AUTO_INCREMENT,
    camo_modelo VARCHAR(100) NOT NULL,
    cama_id INT NOT NULL,
    CAMO_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CAMO_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_camo_marca_modelo (cama_id, camo_modelo),

    CONSTRAINT pk_modelo PRIMARY KEY (camo_id),

    CONSTRAINT fk_camo_marca
        FOREIGN KEY (cama_id)
        REFERENCES carro_marca (cama_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE veiculo (
    veic_id INT NOT NULL AUTO_INCREMENT,
    veic_placa VARCHAR(7) NOT NULL,
    veic_cor VARCHAR(20) NOT NULL,
    veic_ano YEAR NULL,
    pess_id INT NOT NULL,
    camo_id INT NOT NULL,
    VEIC_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    VEIC_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_veiculo_placa (veic_placa),

    CONSTRAINT pk_veiculo PRIMARY KEY (veic_id),

    CONSTRAINT fk_veic_modelo
        FOREIGN KEY (camo_id)
        REFERENCES carro_modelo (camo_id),
    CONSTRAINT fk_veic_pessoa
        FOREIGN KEY (pess_id)
        REFERENCES pessoa (pess_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_camo_veiculo ON veiculo (camo_id);

CREATE TABLE peca (
    peca_id INT NOT NULL AUTO_INCREMENT,
    peca_codigo VARCHAR(30) NOT NULL,
    peca_nome VARCHAR(100) NOT NULL,
    peca_categoria VARCHAR(50) NOT NULL,
    peca_descricao VARCHAR(255) NOT NULL,
    peca_estoque INT NOT NULL DEFAULT 0,
    peca_estoque_minimo INT NOT NULL DEFAULT 0,
    peca_preco DECIMAL(10, 2) NOT NULL,
    peca_ativo BOOL NOT NULL DEFAULT TRUE,
    PECA_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PECA_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_peca_codigo (peca_codigo),

    CONSTRAINT pk_peca PRIMARY KEY (peca_id),

    CONSTRAINT ck_peca_estoque CHECK (peca_estoque >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_nome_peca ON peca (peca_nome);
CREATE INDEX ix_cate_peca ON peca (peca_categoria);
CREATE INDEX ix_esto_peca ON peca (peca_estoque);

CREATE TABLE peca_modelo (
    peca_id INT NOT NULL,
    camo_id INT NOT NULL,
    PEMO_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PEMO_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_peca_modelo PRIMARY KEY (peca_id, camo_id),

    CONSTRAINT fk_pemo_peca
        FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id),
    CONSTRAINT fk_pemo_modelo
        FOREIGN KEY (camo_id)
        REFERENCES carro_modelo (camo_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_camo_pemo ON peca_modelo (camo_id);

CREATE TABLE orcamento (
    orca_id INT NOT NULL AUTO_INCREMENT,
    orca_valor DECIMAL(10, 2) NOT NULL DEFAULT 0,
    orca_status VARCHAR(20) NOT NULL DEFAULT 'aberto',
    orca_formato VARCHAR(20) NOT NULL,
    orca_quilometragem INT NOT NULL,
    veic_id INT NOT NULL,
    func_id INT NOT NULL,
    ORCA_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ORCA_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_orcamento PRIMARY KEY (orca_id),

    CONSTRAINT ck_orca_status
        CHECK (orca_status IN ('aberto', 'orçado', 'aprovado', 'recusado')),

    CONSTRAINT fk_orcamento_veiculo
        FOREIGN KEY (veic_id)
        REFERENCES veiculo (veic_id),
    CONSTRAINT fk_orcamento_funcionario
        FOREIGN KEY (func_id)
        REFERENCES funcionario (pess_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_orcamento_01 ON orcamento (orca_status);
CREATE INDEX ix_orcamento_02 ON orcamento (ORCA_CRIADO_EM);
CREATE INDEX ix_veiculo_orcamento ON orcamento (veic_id);
CREATE INDEX ix_funcionario_orcamento ON orcamento (func_id);

CREATE TABLE orcamento_peca (
    orca_id INT NOT NULL,
    peca_id INT NOT NULL,
    orpe_quantidade INT NOT NULL,
    orpe_preco_unitario DECIMAL(10, 2) NOT NULL,
    ORPE_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ORPE_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_orpe PRIMARY KEY (orca_id, peca_id),

    CONSTRAINT fk_orpe_orcamento
        FOREIGN KEY (orca_id)
        REFERENCES orcamento (orca_id),
    CONSTRAINT fk_orpe_peca
        FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_peca_orpe ON orcamento_peca (peca_id);

CREATE TABLE orcamento_servico (
    orca_id INT NOT NULL,
    serv_id INT NOT NULL,
    orse_valor DECIMAL(10, 2) NOT NULL,
    ORSE_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ORSE_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_orse PRIMARY KEY (orca_id, serv_id),

    CONSTRAINT fk_orse_orcamento
        FOREIGN KEY (orca_id)
        REFERENCES orcamento (orca_id),
    CONSTRAINT fk_orse_servico
        FOREIGN KEY (serv_id)
        REFERENCES servico (serv_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_serv_orse ON orcamento_servico (serv_id);

CREATE TABLE orcamento_historico (
    orhi_id INT NOT NULL AUTO_INCREMENT,
    orhi_status VARCHAR(20) NOT NULL,
    orca_id INT NOT NULL,
    func_id INT NOT NULL,
    ORHI_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_orhi PRIMARY KEY (orhi_id),

    CONSTRAINT ck_orhi_status
        CHECK (orhi_status IN ('aberto', 'orçado', 'aprovado', 'recusado')),

    CONSTRAINT fk_orhi_orcamento
        FOREIGN KEY (orca_id)
        REFERENCES orcamento (orca_id),
    CONSTRAINT fk_orhi_funcionario
        FOREIGN KEY (func_id)
        REFERENCES funcionario (pess_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_orcamento_orhi ON orcamento_historico (orca_id, ORHI_CRIADO_EM);
CREATE INDEX ix_funcionario_orhi ON orcamento_historico (func_id);

CREATE TABLE peca_distribuidora (
    pedi_id INT NOT NULL AUTO_INCREMENT,
    peca_id INT NOT NULL,
    dist_id INT NOT NULL,
    pedi_quantidade INT NOT NULL,
    pedi_custo_unitario DECIMAL(10, 2) NOT NULL,
    PEDI_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PEDI_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_pedi PRIMARY KEY (pedi_id),

    CONSTRAINT fk_pedi_peca
        FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id),
    CONSTRAINT fk_pedi_distribuidora
        FOREIGN KEY (dist_id)
        REFERENCES distribuidora (dist_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_peca_pedi ON peca_distribuidora (peca_id);
CREATE INDEX ix_dist_pedi ON peca_distribuidora (dist_id);

CREATE TABLE ordem_servico (
    os_id INT NOT NULL AUTO_INCREMENT,
    os_detalhes VARCHAR(500),
    os_inicio DATETIME,
    os_fim DATETIME,
    os_status VARCHAR(20) NOT NULL DEFAULT 'aberta',
    orca_id INT NOT NULL,
    box_id INT,
    meca_id INT,
    func_id INT NOT NULL,
    os_box_ativo INT GENERATED ALWAYS AS (IF(os_status = 'em execução', box_id, NULL)) STORED,
    OS_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    OS_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_os_orcamento (orca_id),
    UNIQUE KEY uk_os_box_ativo (os_box_ativo),

    CONSTRAINT pk_ordem_servico PRIMARY KEY (os_id),

    CONSTRAINT ck_os_status
        CHECK (os_status IN ('aberta', 'em execução', 'concluída')),

    CONSTRAINT fk_os_orcamento
        FOREIGN KEY (orca_id)
        REFERENCES orcamento (orca_id),
    CONSTRAINT fk_os_box
        FOREIGN KEY (box_id)
        REFERENCES box (box_id),
    CONSTRAINT fk_os_mecanico
        FOREIGN KEY (meca_id)
        REFERENCES funcionario (pess_id),
    CONSTRAINT fk_os_funcionario
        FOREIGN KEY (func_id)
        REFERENCES funcionario (pess_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_box_os ON ordem_servico (box_id);
CREATE INDEX ix_mecanico_os ON ordem_servico (meca_id);
CREATE INDEX ix_funcionario_os ON ordem_servico (func_id);

CREATE TABLE ordem_servico_peca (
    os_id INT NOT NULL,
    peca_id INT NOT NULL,
    ospe_qt_peca INT NOT NULL,
    ospe_preco_unitario DECIMAL(10, 2) NOT NULL,
    OSPE_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    OSPE_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_ospe PRIMARY KEY (os_id, peca_id),

    CONSTRAINT fk_ospe_os
        FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id),
    CONSTRAINT fk_ospe_peca
        FOREIGN KEY (peca_id)
        REFERENCES peca (peca_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_peca_ospe ON ordem_servico_peca (peca_id);

CREATE TABLE ordem_servico_historico (
    oshi_id INT NOT NULL AUTO_INCREMENT,
    oshi_status VARCHAR(20) NOT NULL,
    os_id INT NOT NULL,
    func_id INT NOT NULL,
    OSHI_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_oshi PRIMARY KEY (oshi_id),

    CONSTRAINT ck_oshi_status
        CHECK (oshi_status IN ('aberta', 'em execução', 'concluída')),

    CONSTRAINT fk_oshi_os
        FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id),
    CONSTRAINT fk_oshi_funcionario
        FOREIGN KEY (func_id)
        REFERENCES funcionario (pess_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_os_oshi ON ordem_servico_historico (os_id, OSHI_CRIADO_EM);
CREATE INDEX ix_funcionario_oshi ON ordem_servico_historico (func_id);

CREATE TABLE pagamento (
    paga_id INT NOT NULL AUTO_INCREMENT,
    paga_metodo VARCHAR(45) NOT NULL,
    paga_valor DECIMAL(10, 2) NOT NULL,
    paga_nota_fiscal VARCHAR(44),
    paga_status VARCHAR(20) NOT NULL,
    paga_parcelado BOOL NOT NULL DEFAULT FALSE,
    paga_dt_pagamento DATETIME,
    os_id INT NOT NULL,
    PAGA_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PAGA_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_pagamento_nf (paga_nota_fiscal),

    CONSTRAINT pk_pagamento PRIMARY KEY (paga_id),

    CONSTRAINT fk_pagamento_os
        FOREIGN KEY (os_id)
        REFERENCES ordem_servico (os_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX ix_os_pagamento ON pagamento (os_id);

CREATE TABLE pagamento_parcelas (
    paga_id INT NOT NULL,
    papa_numero TINYINT UNSIGNED NOT NULL,
    papa_valor DECIMAL(10, 2) NOT NULL,
    papa_vencimento DATE NOT NULL,
    papa_dt_pagamento DATETIME,
    PAPA_CRIADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PAPA_ATUALIZADO_EM DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_pagamento_parcelas PRIMARY KEY (paga_id, papa_numero),

    CONSTRAINT fk_papa_pagamento
        FOREIGN KEY (paga_id)
        REFERENCES pagamento (paga_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

/*Trigger criada por vitor apenas para entendimento didático */
DELIMITER $$

CREATE TRIGGER tg_os_bi_orcamento_aprovado
BEFORE INSERT ON ordem_servico
FOR EACH ROW
BEGIN
    IF (SELECT orca_status FROM orcamento WHERE orca_id = NEW.orca_id) <> 'aprovado' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A ordem de serviço só pode ser criada a partir de um orçamento aprovado.';
    END IF;
END$$

DELIMITER ;
