-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_resposta_auditoria_v (cd_transacao, ie_tipo_registro, nr_sequencia, nr_seq_requisicao, nr_seq_guia, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, nr_seq_origem, ds_observacao, dt_validade, ie_tipo_tabela, cd_servico, ds_servico, ie_autorizado, qt_autorizado, cd_mens_espec_1, cd_mens_espec_2, cd_mens_espec_3, cd_mens_espec_4, cd_mens_espec_5, ds_fim) AS select	00304				cd_transacao,
	1				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora 		cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	nr_seq_execucao   		nr_seq_execucao,
	nr_seq_origem    		nr_seq_origem,
	null				ds_observacao,
	dt_validade  			dt_validade,
	null  				ie_tipo_tabela,
	null    			cd_servico,
	null       			ds_servico,
	null  				ie_autorizado,
	null     			qt_autorizado,
	null				cd_mens_espec_1,
	null				cd_mens_espec_2,
	null				cd_mens_espec_3,
	null				cd_mens_espec_4,
	null				cd_mens_espec_5,
	null				ds_fim
FROM	ptu_resposta_auditoria

union

select	null				cd_transacao,
	2				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null  		      		ie_tipo_cliente,
	null 				cd_unimed_executora,
	null				cd_unimed_beneficiario,
	null   				nr_seq_execucao,
	nr_seq_origem  			nr_seq_origem,
	Elimina_Acentuacao(ds_observacao) ds_observacao,
	null  				dt_validade,
	null  				ie_tipo_tabela,
	null    			cd_servico,
	null       			ds_servico,
	null  				ie_autorizado,
	null     			qt_autorizado,
	null				cd_mens_espec_1,
	null				cd_mens_espec_2,
	null				cd_mens_espec_3,
	null				cd_mens_espec_4,
	null				cd_mens_espec_5,
	null				ds_fim
from	ptu_resposta_auditoria

union

select	null				cd_transacao,
	3				ie_tipo_registro,
	nr_seq_auditoria		nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null	        		ie_tipo_cliente,
	null 				cd_unimed_executora,
	null				cd_unimed_beneficiario,
	null   				nr_seq_execucao,
	nr_seq_origem  			nr_seq_origem,
	null				ds_observacao,
	null  				dt_validade,
	ie_tipo_tabela  		ie_tipo_tabela,
	cd_servico 			cd_servico,
	Elimina_Acentuacao(ds_servico)	ds_servico,
	ie_autorizado			ie_autorizado,
	qt_autorizado  			qt_autorizado,
	ptu_obter_inconsist_trans(nr_seq_guia,nr_seq_requisicao,null,'00304',1,null,cd_servico) cd_mens_espec_1,
	ptu_obter_inconsist_trans(nr_seq_guia,nr_seq_requisicao,null,'00304',2,null,cd_servico) cd_mens_espec_2,
	ptu_obter_inconsist_trans(nr_seq_guia,nr_seq_requisicao,null,'00304',3,null,cd_servico) cd_mens_espec_3,
	ptu_obter_inconsist_trans(nr_seq_guia,nr_seq_requisicao,null,'00304',4,null,cd_servico) cd_mens_espec_4,
	ptu_obter_inconsist_trans(nr_seq_guia,nr_seq_requisicao,null,'00304',5,null,cd_servico) cd_mens_espec_5,
	null				ds_fim
from	ptu_resp_auditoria_servico	b,
	ptu_resposta_auditoria		a
where	b.nr_seq_auditoria		= a.nr_sequencia

union

select	null				cd_transacao,
	4				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null   		     		ie_tipo_cliente,
	null 				cd_unimed_executora,
	null				cd_unimed_beneficiario,
	null   				nr_seq_execucao,
	nr_seq_origem  			nr_seq_origem,
	null 				ds_observacao,
	null  				dt_validade,
	null  				ie_tipo_tabela,
	null    			cd_servico,
	null       			ds_servico,
	null  				ie_autorizado,
	null     			qt_autorizado,
	null				cd_mens_espec_1,
	null				cd_mens_espec_2,
	null				cd_mens_espec_3,
	null				cd_mens_espec_4,
	null				cd_mens_espec_5,
	'FIM$'				ds_fim
from	ptu_resposta_auditoria;

