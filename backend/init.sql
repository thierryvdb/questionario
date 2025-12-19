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

-- Inserir perguntas (20 por categoria)
INSERT INTO questions (category_id, question_text, order_number) VALUES
    -- Linux & Docker (category_id: 1)
    (1, 'Linux: Como você diagnosticaria um servidor que apresenta um Load Average alto, mas o uso de CPU está baixo? (Foco em I/O wait ou processos zumbis)', 1),
    (1, 'Docker: Explique a diferença prática entre as instruções COPY e ADD em um Dockerfile e quando o uso de volumes persistentes pode causar gargalos de performance.', 2),
    (1, 'Troubleshooting: Como você recuperaria o acesso a um servidor Linux onde o sistema de arquivos raiz (/) foi montado apenas como leitura (read-only) devido a erros no disco?', 3),
    (1, 'LVM: Qual o passo a passo para expandir online um sistema de arquivos XFS em LVM, garantindo rollback em caso de falha?', 4),
    (1, 'Systemd: Um serviço entra em loop de crash/restart. Como investigar via journalctl, coredumpctl e overrides da unit para estabilizar o processo?', 5),
    (1, 'Rede: Uma interface reporta flapping intermitente. Quais comandos (dmesg, ethtool, mii-tool ou nmcli) você usaria para isolar driver, cabo ou switch?', 6),
    (1, 'Segurança: Como identificar e liberar um bloqueio de SELinux/AppArmor que impede um serviço web de ler arquivos estáticos?', 7),
    (1, 'Acesso: Você perdeu acesso SSH após um erro no sudoers. Como recuperar com segurança via single-user mode ou console serial?', 8),
    (1, 'Kernel: Depois de um update o servidor não inicia corretamente. Como fazer rollback para o kernel anterior via GRUB e bloquear a versão problemática?', 9),
    (1, 'Pacotes: Como preparar um repositório YUM/APT offline para manter servidores atualizados em um ambiente sem internet?', 10),
    (1, 'Containers: Como definir limites de CPU, memória e PIDs com cgroups/cgroup v2 em containers Docker e qual o efeito prático de cada parâmetro?', 11),
    (1, 'Storage Docker: Compare os drivers overlay2 e devicemapper em termos de consumo de I/O e cenários recomendados.', 12),
    (1, 'Rede Docker: Quando escolher network mode bridge, host ou macvlan e quais implicações de isolamento e troubleshooting cada um traz?', 13),
    (1, 'Logs: Como configurar rotação (max-size/max-file) e driver de log no Docker para evitar que /var/lib/docker ocupe todo o disco?', 14),
    (1, 'Hardening: Quais cuidados ao construir imagens mínimas (Alpine/distroless), usar rootless Docker e rodar scans de CVE?', 15),
    (1, 'Orquestração local: Como healthchecks e políticas restart/depends_on no Docker Compose ajudam na auto-recuperação de serviços críticos?', 16),
    (1, 'Performance: Um container grava muito em um volume NFS e causa latência. Que opções de montagem (async, noatime, rsize/wsize) você avaliaria?', 17),
    (1, 'Debug: Como usar strace, lsof e perf para encontrar file descriptors vazando em um processo Linux que cresce indefinidamente?', 18),
    (1, 'Automação: Um cron diário não roda. Quais verificações de PATH, permissões, SHELL e fuso horário você faria?', 19),
    (1, 'Backup do sistema: Como criar e testar um resgate mínimo usando initramfs/rescue image caso o boot loader seja corrompido?', 20),

    -- Windows Server & Virtualização (category_id: 2)
    (2, 'Active Directory: Em um cenário de desastre onde o controlador de domínio principal (PDC Emulator) pifou, quais são os passos técnicos e cuidados ao "tomar" (seize) as funções FSMO em um servidor secundário?', 21),
    (2, 'Virtualização: O que é o fenômeno de Ballooning em ambientes VMware/Hyper-V e como ele impacta a performance das máquinas virtuais em hosts com memória sobrealocada?', 22),
    (2, 'Cluster: Como funciona o mecanismo de Quorum em um cluster de failover e por que ele é vital para evitar o cenário de Split-Brain?', 23),
    (2, 'AD Replicação: Como diagnosticar falhas de replicação usando repadmin/dcdiag e limpar metadados de um DC removido incorretamente?', 24),
    (2, 'DNS: Quais registros SRV críticos o AD depende e como corrigir clientes que não localizam controladores após migração de DNS?', 25),
    (2, 'GPO: Uma GPO não aplica. Como validar replicação do SYSVOL, permissões de segurança e precedência de links (OU vs site)?', 26),
    (2, 'Time Sync: Como garantir hierarquia NTP correta entre host de virtualização, controladores de domínio e membros para evitar skew de Kerberos?', 27),
    (2, 'Hyper-V/VMware: Live Migration/vMotion falha por CPU incompatível. Quais ajustes de EVC/CPU compatibility você configuraria?', 28),
    (2, 'Storage vMotion: Qual a diferença prática entre vMotion e Storage vMotion e quais pré-requisitos de rede/latência cada um exige?', 29),
    (2, 'Snapshots: Como snapshots prolongados impactam performance e como executar consolidação segura sem interromper as VMs?', 30),
    (2, 'Backup de VM: Um job falha por VSS Writer com erro 0x800423f4. Como identificar qual writer está inconsistente e reiniciá-lo sem reboot?', 31),
    (2, 'CSV/Failover Cluster: Um CSV entra em modo direcionado (Redirected I/O). Quais passos de troubleshooting de rede/NTFS/Cluster você faria?', 32),
    (2, 'DHCP: Como configurar failover em modo Hot-Standby vs Load Balance e quais impactos no tempo de leasing?', 33),
    (2, 'RDS: Licenciamento em modo Per User apresenta excesso de conexões negadas. Como auditar e resetar licenças problemáticas?', 34),
    (2, 'Recursos Hypervisor: Explique reservas, limites e shares de CPU/memória e como eles evitam contenda entre VMs críticas e de baixa prioridade.', 35),
    (2, 'Segurança: Qual o processo seguro para descomissionar um Domain Controller incluindo remoção de funções, FSMO e limpeza de sites?', 36),
    (2, 'Clusters: Como lidar com um possível USN Rollback e quais indicadores apontam para necessidade de rebuild de DC?', 37),
    (2, 'VM Performance: Como identificar se a lentidão vem de storage (latência) ou CPU Ready em VMware e que métricas observar?', 38),
    (2, 'Backup/Restore AD: Qual o procedimento para Autoritative Restore de uma OU específica usando ntdsutil?', 39),
    (2, 'Recuperação: Uma VM não inicia por corrupção do bootloader Windows. Como usar WinRE/BCDBoot para reparar sem restaurar backup completo?', 40),

    -- Backups & Soluções Dell (category_id: 3)
    (3, 'Estratégia: Explique o conceito de backup imutável e como você implementaria a regra 3-2-1 em uma infraestrutura moderna.', 41),
    (3, 'Hardware Dell: Como você utiliza o iDRAC para diagnosticar uma falha de barramento PCIe ou um erro de memória "Uncorrectable ECC" remotamente?', 42),
    (3, 'Storage: Qual a diferença de performance e resiliência entre um arranjo RAID 6 e um RAID 10 em um servidor Dell PowerEdge com 8 discos?', 43),
    (3, 'Política: Compare backups incrementais-para-sempre com full sintético e diferenciais em termos de janela e uso de rede.', 44),
    (3, 'RPO/RTO: Como você determina RPO e RTO por serviço e traduz isso em frequência de jobs e janelas de backup?', 45),
    (3, 'Teste de restauração: Como validar rotineiramente a recuperabilidade (test restore/sure backup) e documentar evidências para auditoria?', 46),
    (3, 'Air-gap: Que opções de cópia offline/air-gapped você usaria para mitigar ransomware além de imutabilidade lógica?', 47),
    (3, 'Desempenho: Como calcular throughput necessário (Gbps/IOPS) para fechar a janela de backup dentro do SLA em links WAN?', 48),
    (3, 'Deduplicação: Quais cuidados ao usar appliances de dedupe em relação a streams paralelos e compressão dupla?', 49),
    (3, 'Snapshots: Diferença entre snapshot de storage e backup consistente de aplicação. Quando cada um é suficiente?', 50),
    (3, 'Aplicações: Como garantir consistência de bancos (SQL/Oracle) usando quiesce, VSS ou plugins específicos?', 51),
    (3, 'Retention: Como desenhar políticas GFS (avô/pai/filho) e rotação de fitas para retenções longas?', 52),
    (3, 'Nuvem: O que considerar ao usar repositório de nuvem S3 compatível para offsite (latência, egress, reidratação)?', 53),
    (3, 'Dell OMSA/iDRAC: Como planejar janelas para atualização de firmware de controladoras/BIOS sem impactar tarefas de backup?', 54),
    (3, 'Rede de backup: Como segmentar tráfego de backup em VLAN dedicada e configurar throttling para não saturar a rede de produção?', 55),
    (3, 'Restore granular: Como restaurar apenas um arquivo de dentro de um backup de VM sem recuperar a VM inteira?', 56),
    (3, 'BCDR: Como orquestrar failover site-to-site incluindo prioridade de serviços e ordem de boot das VMs?', 57),
    (3, 'Logs: Como monitorar falhas recorrentes de job (ex.: status warning) e automatizar reexecução e notificações?', 58),
    (3, 'Storage Dell: Quais indicadores no OpenManage Enterprise mostram pré-falha de disco/controladora que devem acionar troca preventiva?', 59),
    (3, 'Compliance: Como criptografar backups em trânsito e em repouso e gerenciar rotação/backup de chaves?', 60),

    -- Switches & Protocolos de Comunicação (category_id: 4)
    (4, 'Protocolos: Explique o funcionamento do STP (Spanning Tree Protocol) e como você identificaria qual switch da rede se tornou o Root Bridge indevidamente, causando lentidão.', 61),
    (4, 'VLANs: Como funciona o entroncamento (Tagging 802.1Q) e quais os riscos de segurança de permitir a "VLAN nativa" em portas de Trunk?', 62),
    (4, 'Roteamento: Qual a diferença entre protocolos de roteamento Link-State (ex: OSPF) e Distance-Vector (ex: BGP) em termos de convergência de rede?', 63),
    (4, 'STP avançado: Compare STP, RSTP e MSTP e quando usar Root Guard/BPDU Guard para evitar loops causados por switches não gerenciados.', 64),
    (4, 'Agregação: Quando preferir LACP (802.3ad) versus EtherChannel estático e como o algoritmo de hashing influencia a distribuição?', 65),
    (4, 'Segurança L2: Como DHCP Snooping, Dynamic ARP Inspection e IP Source Guard trabalham juntos para evitar spoofing?', 66),
    (4, 'OSPF: Qual o papel da área backbone 0 e quando usar áreas Stub/NSSA para reduzir LSAs?', 67),
    (4, 'BGP: Como route-reflectors evitam full-mesh iBGP e que cuidados com cluster-id/loop prevention?', 68),
    (4, 'QoS: Onde definir o ponto de confiança DSCP/CoS na borda e como reclassificar tráfego suspeito?', 69),
    (4, 'PoE: Como calcular orçamento PoE de um switch e priorizar portas de telefones críticos em caso de falta de energia?', 70),
    (4, 'MTU: Um link com jumbo frames causa fragmentação. Como alinhar MTU e ativar PMTUD/ICMP permitidos para evitar blackholes?', 71),
    (4, 'Multicast: Como IGMP Snooping e PIM (Sparse/Dense) funcionam juntos e o que indica flooding indevido de multicast?', 72),
    (4, 'IPv6: Como RA Guard e DHCPv6 Guard protegem contra roteadores rogue em redes dual-stack?', 73),
    (4, 'Monitoramento: Quando usar SPAN vs RSPAN/ERSPAN para capturar tráfego sem derrubar a porta?', 74),
    (4, 'Alta disponibilidade: Compare HSRP/VRRP/GLBP e quando habilitar preemption e tracking de interface.', 75),
    (4, 'Autenticação: Como 802.1X com MAB e Voice VLAN impactam o boot de telefones IP e dispositivos legados?', 76),
    (4, 'Logs: Quais eventos críticos você encaminharia via Syslog/SNMP trap para detectar loops ou quedas de uplink rapidamente?', 77),
    (4, 'Cabling: Como usar TDR/diagnóstico óptico no switch para identificar rompimento parcial de cabo ou atenuação?', 78),
    (4, 'ACL: Diferença entre ACL aplicada inbound/outbound em SVI versus em portas físicas e impacto na ordem de processamento?', 79),
    (4, 'Automação: Como usar templates/Ansible para garantir configuração padrão (AAA, NTP, banners) em dezenas de switches?', 80),

    -- VoIP & Firewall (category_id: 5)
    (5, 'VoIP: Quais são os principais parâmetros de rede (Jitter, Latência e Perda de Pacotes) que degradam uma chamada VoIP e como o protocolo QoS deve ser configurado no switch para mitigar isso?', 81),
    (5, 'Troubleshooting SIP: O que o código de erro "403 Forbidden" ou "408 Request Timeout" geralmente indica em uma sinalização SIP?', 82),
    (5, 'Firewall: Explique a diferença entre um Firewall Stateful e um Deep Packet Inspection (DPI). Como você liberaria o tráfego de uma aplicação que usa portas dinâmicas?', 83),
    (5, 'SIP ALG: Por que muitos fabricantes recomendam desativar SIP ALG e quais sintomas ele causa em registros ou áudio?', 84),
    (5, 'NAT: Como manter extensões remotas atrás de NAT estáveis usando keepalives, STUN/TURN ou sessão pinhole?', 85),
    (5, 'Segurança SIP: Como habilitar TLS para sinalização e SRTP para mídia e validar certificados entre PBX e endpoints?', 86),
    (5, 'Áudio unilateral: Quais verificações em ACL/NAT/firewall você faria quando o áudio só funciona em uma direção?', 87),
    (5, 'SBC: Qual o papel de um Session Border Controller na proteção e interoperação de um SIP Trunk com operadora?', 88),
    (5, 'Fax sobre IP: Diferença entre pass-through (G.711) e T.38 e quando ajustar jitter buffer/ECM?', 89),
    (5, 'QoS avançado: Como mapear DSCP EF/CS3/AF31 para filas de prioridade no firewall e no switch para voz e sinalização?', 90),
    (5, 'Portas dinâmicas: Como dimensionar e documentar ranges RTP em firewalls stateful para evitar conflitos com outras aplicações?', 91),
    (5, 'IDS/IPS: Como lidar com falsos positivos em assinaturas SIP/RTP que derrubam chamadas sem desabilitar proteção?', 92),
    (5, 'VPN: Chamadas sobre VPN site-to-site estão com jitter alto. Que ajustes de MTU, QoS e criptografia você avaliaria?', 93),
    (5, 'Resiliência: Como planejar failover de tronco SIP entre duas operadoras usando DNS SRV ou roteamento por prioridade?', 94),
    (5, 'DDoS VoIP: Como mitigar um ataque de REGISTER/INVITE flood na porta 5060 sem bloquear tráfego legítimo?', 95),
    (5, 'Monitoramento: Como medir MOS e jitter buffer drops e correlacionar com logs de firewall para RCA?', 96),
    (5, 'Provisionamento: Como automatizar configuração de telefones IP via DHCP Option 66/160 e arquivos de provisionamento?', 97),
    (5, 'Políticas: Como segmentar Voice VLAN e aplicar ACLs que permitam apenas sinalização/mídia necessárias ao PBX?', 98),
    (5, 'Firewalling: Diferença entre NAT simétrico e assimétrico para VoIP e como isso afeta chamadas externas?', 99),
    (5, 'Logs: Como usar capturas pcap e ferramentas como sngrep para reconstruir uma chamada SIP durante troubleshooting?', 100),

    -- Gestão de Chamados (category_id: 6)
    (6, 'Processos: Dentro do framework ITIL (usado no Ivanti), qual a diferença técnica entre a gestão de um Incidente e a gestão de um Problema?', 101),
    (6, 'SLA: Como você lida com um chamado de "Crise/Severidade 1" onde o SLA está prestes a estourar, mas a solução depende de um fornecedor externo?', 102),
    (6, 'CMDB: Qual a importância de manter o CMDB (Configuration Management Database) atualizado no Ivanti para a análise de impacto em mudanças de infraestrutura?', 103),
    (6, 'Prioridade: Como construir uma matriz de impacto x urgência para classificar automaticamente a prioridade de incidentes?', 104),
    (6, 'Mudança: Qual o fluxo mínimo para uma Change Emergencial versus Normal, incluindo aprovação CAB e janela de implantação?', 105),
    (6, 'RCA: Como conduzir um 5 Whys/Ishikawa para incidentes repetitivos e registrar ações de longo prazo no módulo de Problemas?', 106),
    (6, 'Relacionamentos: Como vincular incidentes a itens de configuração (CI) e a mudanças para manter rastreabilidade completa?', 107),
    (6, 'Comunicação: Que plano de comunicação você segue em Major Incidents (bridge, status page, ETA) para reduzir ansiedade do negócio?', 108),
    (6, 'Reabertura: Em quais condições você reabre um incidente versus abrir um novo, e como isso afeta métricas de SLA?', 109),
    (6, 'SLA Clock: Quando o relógio de SLA deve ser pausado (aguardando cliente/fornecedor) e como evidenciar isso no sistema?', 110),
    (6, 'Base de conhecimento: Como estruturar e publicar artigos KCS e vinculá-los a incidentes para medir taxa de reutilização?', 111),
    (6, 'Escalonamento: Quando usar swarming em vez de escalonamento hierárquico e como registrar quem assumiu?', 112),
    (6, 'Release vs Change: Como diferenciar pedidos de mudança padrão de releases agendados para evitar bypass do CAB?', 113),
    (6, 'On-call: Que informações essenciais um Runbook de plantão deve conter para reduzir MTTR em horário crítico?', 114),
    (6, 'CSI: Como coletar dados de incidentes/problemas para ciclos de melhoria contínua (CSIP) e priorizar backlog?', 115),
    (6, 'Catálogo de Serviços: Quais campos mínimos (CI associado, SLA, grupo responsável, custo) você mantém em cada item de catálogo?', 116),
    (6, 'Descoberta: Como automatizar integração de inventário/Discovery com CMDB sem gerar duplicidade ou CI órfão?', 117),
    (6, 'Auditoria: Como garantir rastreabilidade de mudanças para conformidade (SOX/ISO) incluindo aprovação, testes e verificação?', 118),
    (6, 'KPIs: Quais KPIs você monitora (MTTR, MTBF, FCR, backlog envelhecido) e como reage a tendências negativas?', 119),
    (6, 'Major Incident Manager: Quais responsabilidades e handoffs são esperados durante e após a resolução de um incidente crítico?', 120);

-- Criar índices para melhorar performance
CREATE INDEX idx_questions_category ON questions(category_id);
CREATE INDEX idx_assessment_scores_assessment ON assessment_scores(assessment_id);
CREATE INDEX idx_assessment_scores_question ON assessment_scores(question_id);
