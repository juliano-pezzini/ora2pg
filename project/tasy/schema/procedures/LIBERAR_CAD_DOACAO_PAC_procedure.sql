-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_cad_doacao_pac ( nr_seq_doacao_p bigint) AS $body$
DECLARE

 
nr_seq_status_doacao_w		bigint;
ie_amostra_reteste_w		varchar(1);
ie_triagem_amostra_w		varchar(1);
ie_doacao_autologa_afer_w	varchar(1);
nm_usuario_w			usuario.nm_usuario%type;


BEGIN 
 
ie_triagem_amostra_w := obter_valor_param_usuario(450, 324, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
 
/* Verifica se é uma doação do tipo Autologo e tipo coleta Aférese */
 
select 	coalesce(max('S'),'N') 
into STRICT	ie_doacao_autologa_afer_w 
from	san_doacao a, 
	san_tipo_doacao b 
where	b.nr_sequencia = a.nr_seq_tipo 
and	b.ie_classif_doacao = 'A' 
and	a.ie_tipo_coleta = 3 
and	a.nr_sequencia = nr_seq_doacao_p;
 
if (ie_doacao_autologa_afer_w = 'S') then 
 
	update	san_doacao 
	set	dt_atualizacao = clock_timestamp(), 
		nm_usuario = nm_usuario_w, 
		dt_liberacao_cadastro = clock_timestamp() 
	where	nr_sequencia = nr_seq_doacao_p;
	 
	CALL san_atualizar_status_doacao(nr_seq_doacao_p, nm_usuario_w, 1);
	CALL san_gerar_seq_chegada_coleta(nr_seq_doacao_p, nm_usuario_w);
	CALL atualizar_san_coleta_amostra(nr_seq_doacao_p, nm_usuario_w);
 
else 
 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_amostra_reteste_w 
	from	san_doacao 
	where	nr_sequencia 	= nr_seq_doacao_p 
	and	ie_tipo_coleta 	= 2 
	and	(nr_seq_doacao_amostra IS NOT NULL AND nr_seq_doacao_amostra::text <> '');
	 
	if (ie_triagem_amostra_w = 'A') and (ie_amostra_reteste_w = 'S') then 
		select	coalesce(max(nr_sequencia),0) 
		into STRICT	nr_seq_status_doacao_w 
		from  san_status_doacao 
		where  ie_status_doacao = 3 
		and   coalesce(ie_situacao,'A') = 'A';
	 
	else 
		select	coalesce(max(nr_sequencia),0) 
		into STRICT	nr_seq_status_doacao_w 
		from  san_status_doacao 
		where  ie_status_doacao = 2 
		and   coalesce(ie_situacao,'A') = 'A';
	end if;
	 
	if (nr_seq_status_doacao_w > 0) then 
		 
		update	san_doacao 
		set	dt_atualizacao = clock_timestamp(), 
			nm_usuario = nm_usuario_w, 
			dt_liberacao_cadastro = clock_timestamp(), 
			dt_triagem_fisica = clock_timestamp(), 
			nr_Seq_status = nr_seq_status_doacao_w 
		where	nr_Sequencia = nr_seq_doacao_p;
	 
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_cad_doacao_pac ( nr_seq_doacao_p bigint) FROM PUBLIC;
