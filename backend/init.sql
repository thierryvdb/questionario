-- Criação do banco de dados e tabelas

-- Tabela de categorias
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de perguntas
CREATE TABLE IF NOT EXISTS questions (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    order_number INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de respostas/avaliações
CREATE TABLE IF NOT EXISTS assessments (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(255),
    user_email VARCHAR(255),
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de scores por pergunta
CREATE TABLE IF NOT EXISTS assessment_scores (
    id SERIAL PRIMARY KEY,
    assessment_id INTEGER REFERENCES assessments(id) ON DELETE CASCADE,
    question_id INTEGER REFERENCES questions(id) ON DELETE CASCADE,
    score INTEGER CHECK (score >= 0 AND score <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir categorias
INSERT INTO categories (name, description) VALUES
    ('Linux & Docker', 'Conhecimentos em sistemas Linux, containerização e troubleshooting'),
    ('Windows Server & Virtualização', 'Active Directory, VMware/Hyper-V e clusters'),
    ('Backups & Soluções Dell', 'Estratégias de backup, hardware Dell e storage'),
    ('Switches & Protocolos de Comunicação', 'Redes, protocolos, VLANs e roteamento'),
    ('VoIP & Firewall', 'Telefonia IP, segurança e configuração de firewall'),
    ('Gestão de Chamados (Ivanti/ITIL)', 'Processos ITIL, SLA e CMDB');

-- Inserir perguntas
INSERT INTO questions (category_id, question_text, order_number) VALUES
    -- Linux & Docker (category_id: 1)
    (1, 'Linux: Como você diagnosticaria um servidor que apresenta um Load Average alto, mas o uso de CPU está baixo? (Foco em I/O wait ou processos zumbis)', 1),
    (1, 'Docker: Explique a diferença prática entre as instruções COPY e ADD em um Dockerfile e quando o uso de volumes persistentes pode causar gargalos de performance.', 2),
    (1, 'Troubleshooting: Como você recuperaria o acesso a um servidor Linux onde o sistema de arquivos raiz (/) foi montado apenas como leitura (read-only) devido a erros no disco?', 3),

    -- Windows Server & Virtualização (category_id: 2)
    (2, 'Active Directory: Em um cenário de desastre onde o controlador de domínio principal (PDC Emulator) pifou, quais são os passos técnicos e cuidados ao "tomar" (seize) as funções FSMO em um servidor secundário?', 4),
    (2, 'Virtualização: O que é o fenômeno de Ballooning em ambientes VMware/Hyper-V e como ele impacta a performance das máquinas virtuais em hosts com memória sobrealocada?', 5),
    (2, 'Cluster: Como funciona o mecanismo de Quorum em um cluster de failover e por que ele é vital para evitar o cenário de Split-Brain?', 6),

    -- Backups & Soluções Dell (category_id: 3)
    (3, 'Estratégia: Explique o conceito de backup imutável e como você implementaria a regra 3-2-1 em uma infraestrutura moderna.', 7),
    (3, 'Hardware Dell: Como você utiliza o iDRAC para diagnosticar uma falha de barramento PCIe ou um erro de memória "Uncorrectable ECC" remotamente?', 8),
    (3, 'Storage: Qual a diferença de performance e resiliência entre um arranjo RAID 6 e um RAID 10 em um servidor Dell PowerEdge com 8 discos?', 9),

    -- Switches & Protocolos de Comunicação (category_id: 4)
    (4, 'Protocolos: Explique o funcionamento do STP (Spanning Tree Protocol) e como você identificaria qual switch da rede se tornou o Root Bridge indevidamente, causando lentidão.', 10),
    (4, 'VLANs: Como funciona o entroncamento (Tagging 802.1Q) e quais os riscos de segurança de permitir a "VLAN nativa" em portas de Trunk?', 11),
    (4, 'Roteamento: Qual a diferença entre protocolos de roteamento Link-State (ex: OSPF) e Distance-Vector (ex: BGP) em termos de convergência de rede?', 12),

    -- VoIP & Firewall (category_id: 5)
    (5, 'VoIP: Quais são os principais parâmetros de rede (Jitter, Latência e Perda de Pacotes) que degradam uma chamada VoIP e como o protocolo QoS deve ser configurado no switch para mitigar isso?', 13),
    (5, 'Troubleshooting SIP: O que o código de erro "403 Forbidden" ou "408 Request Timeout" geralmente indica em uma sinalização SIP?', 14),
    (5, 'Firewall: Explique a diferença entre um Firewall Stateful e um Deep Packet Inspection (DPI). Como você liberaria o tráfego de uma aplicação que usa portas dinâmicas?', 15),

    -- Gestão de Chamados (category_id: 6)
    (6, 'Processos: Dentro do framework ITIL (usado no Ivanti), qual a diferença técnica entre a gestão de um Incidente e a gestão de um Problema?', 16),
    (6, 'SLA: Como você lida com um chamado de "Crise/Severidade 1" onde o SLA está prestes a estourar, mas a solução depende de um fornecedor externo?', 17),
    (6, 'CMDB: Qual a importância de manter o CMDB (Configuration Management Database) atualizado no Ivanti para a análise de impacto em mudanças de infraestrutura?', 18);

-- Criar índices para melhorar performance
CREATE INDEX idx_questions_category ON questions(category_id);
CREATE INDEX idx_assessment_scores_assessment ON assessment_scores(assessment_id);
CREATE INDEX idx_assessment_scores_question ON assessment_scores(question_id);
