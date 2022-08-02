-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sac_ie_libera_boletim ( nm_usuario_p text, nr_sequencia_p bigint, ie_opcao_p text, ds_motivo_p text default '') AS $body$
DECLARE

 
/*	ie_opcao_p 
L	- liberar 
D	- desfazer liberação 
E	- encerrar boletim 
DE	- desfazer encerramento boletim 
*/
 
 
nr_seq_atend_pls_w		bigint;
nr_seq_evento_atend_w		bigint;
dt_fim_evento_w			timestamp;


BEGIN 
if (ie_opcao_p = 'L')	then 
 
	update	sac_boletim_ocorrencia 
	set	nm_usuario	= nm_usuario_p, 
		nm_usuario_lib	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp(), 
		dt_liberacao	= clock_timestamp() 
	where	nr_sequencia	= nr_sequencia_p;
	 
elsif (ie_opcao_p = 'D') then 
 
	update	sac_boletim_ocorrencia 
	set	nm_usuario	= nm_usuario_p, 
		nm_usuario_lib	= '', 
		dt_atualizacao	= clock_timestamp(), 
		dt_liberacao	 = NULL 
	where	nr_sequencia	= nr_sequencia_p;
 
elsif (ie_opcao_p = 'E') then 
 
	update	sac_boletim_ocorrencia 
	set	nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp(), 
		dt_encerramento	= clock_timestamp() 
	where	nr_sequencia	= nr_sequencia_p;
	 
	/*Alexandre OPS - OS 395835, - Foi colocado este tratamento para quando encerrar o boletim de ocorrência, tambem seja alterado o status do atendimento (call center) */
 
	begin 
	select	nr_atend_pls, 
		nr_seq_evento_atend 
	into STRICT	nr_seq_atend_pls_w, 
		nr_seq_evento_atend_w 
	from	sac_boletim_ocorrencia 
	where	nr_sequencia	= nr_sequencia_p;
	 
	select	dt_fim_evento 
	into STRICT	dt_fim_evento_w 
	from	pls_atendimento_evento 
	where	nr_sequencia = nr_seq_evento_atend_w;
 
	if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') and (dt_fim_evento_w IS NOT NULL AND dt_fim_evento_w::text <> '')	then 
		CALL pls_finalizar_atendimento(	nr_seq_atend_pls_w, nr_seq_evento_atend_w, null, 
						null, nm_usuario_p);
	end if;	
	exception 
	when others then 
			nr_seq_evento_atend_w := null;
	end;
	 
elsif (ie_opcao_p = 'DE') then 
	 
	update	sac_boletim_ocorrencia 
	set	nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp(), 
		dt_encerramento	 = NULL 
	where	nr_sequencia	= nr_sequencia_p;
	 
	CALL gravar_hist_alter_bo(nm_usuario_p, nr_sequencia_p, null, 'B', wheb_mensagem_pck.get_texto(799466), wheb_mensagem_pck.get_texto(799467), ds_motivo_p);
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sac_ie_libera_boletim ( nm_usuario_p text, nr_sequencia_p bigint, ie_opcao_p text, ds_motivo_p text default '') FROM PUBLIC;

