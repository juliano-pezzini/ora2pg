-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_inf_adic_glosa_monit () AS $body$
DECLARE


qt_reg_w	integer;


BEGIN

select	count(1)
into STRICT	qt_reg_w
from	pls_monitor_tiss_inf_glosa;

if (qt_reg_w = 0) then
	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (17, 'Motivo: O número do CNES do prestador executor está incorreto.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar o CNES do prestador executor no cadastro de pessoa física ou pessoa jurídica, conforme prestador executor.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar o cadastro.' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Observação: Caso o prestador ainda não possua um CNES, deverá ser informado o código ''9999999''.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1202');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (15, 'Motivo: O código do cartão nacional de saúde do beneficiário é inválido.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Atualizar o número do cartão nacional de saúde no cadastro de pessoa física do beneficiário.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar o cadastro.' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1002');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (16, 'Motivo: O plano informado para beneficiário não corresponde a nenhum plano na base da ANS.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar o plano do beneficiário no cadastro do beneficiário' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar o cadastro.' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1024');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (18, 'Motivo: O CPF ou CNPJ forneceido é inválido.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Para prestador PJ, é necessário ajustar a informação no cadastro do prestador, para prestadores PF, é necessário ajustar o cadastro no cadastro de PF.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar o cadastro.' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1206');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (19, 'Motivo: Não foi encontrado, na base da ANS, um registro com código de guia correspondente ao informado. A crítica normalmente ocorre quando é enviado um registro de Alteração ou Exclusão, porém, não há registros com mesma identificação na base da ANS.'
	|| pls_util_pck.enter_w || pls_util_pck.enter_w ||
	'Como ajustar: Verificar se houve registro correspondete aceito na ANS.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Desfazer os dados gerados.' || pls_util_pck.enter_w ||
	'- Ajustar o código da guia (caso necessário)' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1307');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (20, 'Motivo: Guia enviada em duplicidade, ou duas contas distintas possuem mesma chave de registro.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Alterar o código da guia prestador da conta glosada.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Na aba "Retorno / Contas glosadas", verificar se a conta que recebeu a glosa possui a informação "Seq monitor guia", caso contrário, identificar o registro através da funcionalidade "BD - Selecionar conta para registro não identificado".' || pls_util_pck.enter_w ||
	'- Navegar até a aba "Retorno / Lote", selecionar o lote de retorno que possui a glosa e aplicar a funcionalidade "BD - Alterar número guia prestador para sequencial da conta".' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1308');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (21, 'Motivo: Data preenchida fora do padrão TISS.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar a quando campo a glosa está referenciando e ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1323');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (22, 'Motivo: Código de diagnóstico informado não corresponde com a tabela CID10.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1509');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (23, 'Motivo: Tipo de atendimento inválido (fora do padrão TISS), ou não informado (Registro obrigatório para as guias de SP/SADT).' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1602');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (24, 'Motivo: Tipo de consulta fora do padrão TISS.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1603');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (25, 'Motivo: Ocorre quando houve uma divergência de valores entre o primeiro e o segundo envio da guia.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar os registros divergentes através da funcionalidade "BD - Comparar com primeiro envio", disponível na aba "Retorno / Contas glosadas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação divergente' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1705');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (26, 'Motivo: Ocorre quando houve uma divergência de valores entre o primeiro e o segundo envio da guia.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar os registros divergentes através da funcionalidade "BD - Comparar com primeiro envio", disponível na aba "Retorno / Contas glosadas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação divergente' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1706');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (27, 'Motivo: Pode ocorrer por alguns motivos:' || pls_util_pck.enter_w ||
	'- Houve alguma alteração entre o primeiro e o segundo envio de um dos itens da guia.' || pls_util_pck.enter_w ||
	'	Como ajustar: Verificar os registros divergentes através da funcionalidade "BD - Comparar com primeiro envio", disponível na aba "Retorno / Contas glosadas".' || pls_util_pck.enter_w ||
	'- Item próprio da operadora envio fora da tabela referência "00".' || pls_util_pck.enter_w ||
	'	Como ajustar: Verificar as informações de tabela referência e grupo ANS do item.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação divergente' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1801');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (28, 'Motivo: A quantidade apresentado do item de ser sempre maior que zero.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar se existe algum item com quantidade apresentada igual ou menor que zero.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '1806');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (29, 'Motivo: Item TUSS que, segundo manual ANS, deveria ser enviado de forma consolidada, enviado de forma individualizada.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar as informações de tabela referência e grupo ANS do item.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação divergente' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '2601');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (30, 'Motivo: O arquivo enviado está fora do padrão TISS.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Validar o arquivo de envio em um validador TISS, verificar e corrigir a informação fora do padrão.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação divergente' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5001');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (31, 'Motivo: O arquivo enviado para ANS está com o Hash incorreto.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Gerar um novo lote para a competência e enviá-lo novamente para ANS, caso a inconsistência persista, favor entrar em contato com o suporte Philips.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5014');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (32, 'Motivo: Data de registro informada fora da competência informada no lote.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Gerar um novo lote para a competência e enviá-lo novamente para ANS, caso a inconsistência persista, favor entrar em contato com o suporte Philips.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5025');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (33, 'Motivo:' || pls_util_pck.enter_w ||
	'- Quando aplicado sobre o campo 041, trata-se de uma alteração no diagnóstico da conta entre o primeiro e o segundo envio.' || pls_util_pck.enter_w ||
	'- Quando aplicado sobre o campo 071, houve uma alteração na identificação do item (código de grupo ANS e código de tabela referência) entre o primeiro e o segundo envio.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar os registros divergentes através da funcionalidade "BD - Comparar com primeiro envio", disponível na aba "Retorno / Contas glosadas" e ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação divergente' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5029');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (34, 'Motivo: O código do município IBGE do prestador está incorreto' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Para prestador PJ, é necessário ajustar a informação no cadastro dPJ, para prestadores PF, é necessário ajustar o cadastro no cadastro de PF, complemento comercial.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar o cadastro.' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5030');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (35, 'Motivo: Caráter de atendimento inválido (fora do padrão TISS).' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5031');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (36, 'Motivo: Motivo de encerramento inválido (fora do padrão TISS).' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Ajustar a informação através da funcionalidade "BD - Ajustar informações conta", disponível na aba "Envio / Contas".' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5033');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (37, 'Motivo: O valor total do somatório dos tipos de despesa não está de acordo com o valor total pago. O valor total da guia, deve ser a soma dos campos:' || pls_util_pck.enter_w ||
	'- Valor total procedimento' || pls_util_pck.enter_w ||
	'- Valor total diária' || pls_util_pck.enter_w ||
	'- Valor total taxa' || pls_util_pck.enter_w ||
	'- Valor total medicamento' || pls_util_pck.enter_w ||
	'- Valor total material' || pls_util_pck.enter_w ||
	'- Valor total OPME' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Verificar se não há um item com tabela referência não correspondete ao tipo de despesa.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Tipo de despesa x tabela referência:' || pls_util_pck.enter_w ||
	'Materiais e OPME: Tabela 19, 00, 98' || pls_util_pck.enter_w ||
	'Medicamentos: Tabela 19, 20, 00, 98' || pls_util_pck.enter_w ||
	'Gases medicinais: Tabela 18, 00, 98' || pls_util_pck.enter_w ||
	'Taxas e diárias: Tabela 18, 00, 98' || pls_util_pck.enter_w ||
	'Pacotes: Tabela 00, 98' || pls_util_pck.enter_w ||
	'Procedimentos: Tabela 22, 00, 98' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência'
	, clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5034');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (38, 'Motivo: Código do grupo ANS informado não corresponde com o padrão TISS' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Identificar a forma de geração da informaçãoa través do campo "Origem grupo"  e ajustar conforme origem.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5036');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (39, 'Motivo: O valor total apresentado está diferente do somatório dos valores apresentado dos itens.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Identificar o item com valor divergente e ajustar.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5042');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (40, 'Motivo: Para este tipo de guia, não pode ser informado o valor a quando o campo glosado referencia.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Identificar o valor gerado incorretamente e ajustar.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Ações necessárias:' || pls_util_pck.enter_w ||
	'- Ajustar a informação indicada' || pls_util_pck.enter_w ||
	'- Gerar um novo lote para a competência', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5050');

	insert into PLS_MONITOR_TISS_INF_GLOSA(NR_SEQUENCIA, DS_OBSERVACAO, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_MOTIVO_TISS)
	values (41, 'Motivo: Item gerado em duplicidade ou não agrupado na geração do arquivo.' || pls_util_pck.enter_w ||
	pls_util_pck.enter_w ||
	'Como ajustar: Entrar em contato com o suporte Philips.', clock_timestamp(), 'aedemuth', clock_timestamp(), 'aedemuth', '5053');
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_inf_adic_glosa_monit () FROM PUBLIC;

