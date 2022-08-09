-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_gerar_ated_ext_guia (nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(10);
nr_seq_hc_w		bigint;
dt_autorizacao_w	timestamp;
cd_cgc_w		varchar(14);
			

BEGIN 
 
select	max(a.cd_pessoa_fisica), 
	max(b.dt_autorizacao), 
	max(Pls_Obter_Dados_Prestador(b.Nr_Seq_Prestador, 'CGC')) 
into STRICT	cd_pessoa_fisica_w, 
	dt_autorizacao_w, 
	cd_cgc_w 
from	pls_guia_plano b, 
	pls_segurado a 
where	a.nr_sequencia = b.nr_seq_segurado 
and	b.nr_sequencia = nr_seq_guia_p 
and (b.ie_tipo_guia = '1' or b.ie_consulta_urgencia = 'S');
 
select	max(nr_sequencia) 
into STRICT	nr_seq_hc_w 
from	paciente_home_care 
where	cd_pessoa_fisica = cd_pessoa_fisica_w 
and	coalesce(dt_final::text, '') = '' 
and	ie_situacao = 'A';
 
if (nr_seq_hc_w > 0) then 
 
insert into paciente_hc_atend_ext(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_paciente, 
				dt_atendimento, 
				cd_cgc, 
				ds_observacao, 
				dt_alta, 
				nr_seq_guia) 
			values (nextval('paciente_hc_atend_ext_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_hc_w, 
				dt_autorizacao_w, 
				cd_cgc_w, 
				null, 
				null,--Data da alta 
				nr_seq_guia_p);
commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_gerar_ated_ext_guia (nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;
