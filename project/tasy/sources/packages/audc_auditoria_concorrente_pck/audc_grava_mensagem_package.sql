-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE audc_auditoria_concorrente_pck.audc_grava_mensagem ( ds_mensagem_p audc_mensagem_imp.ds_mensagem%type, cd_mensagem_p audc_mensagem_imp.cd_mensagem%type, nr_seq_audc_atend_imp_p audc_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN


if (nr_seq_audc_atend_imp_p IS NOT NULL AND nr_seq_audc_atend_imp_p::text <> '' AND cd_mensagem_p IS NOT NULL AND cd_mensagem_p::text <> '') then
	
	insert into audc_mensagem_imp(
 		nr_sequencia, ds_mensagem, dt_atualizacao,
 		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_seq_audc_atend_imp, nr_seq_audc_proc_imp, nr_seq_audc_mat_imp,    
 		cd_mensagem)
	values (nextval('audc_mensagem_imp_seq'), ds_mensagem_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nr_seq_audc_atend_imp_p, null, null, 
		cd_mensagem_p);
		
	update	audc_atendimento_imp
	set	ie_status_auditoria = 'N',
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_audc_atend_imp_p;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE audc_auditoria_concorrente_pck.audc_grava_mensagem ( ds_mensagem_p audc_mensagem_imp.ds_mensagem%type, cd_mensagem_p audc_mensagem_imp.cd_mensagem%type, nr_seq_audc_atend_imp_p audc_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;