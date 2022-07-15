-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_comunic_reinternacao ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_perfil_p text, qt_dia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

qt_reg_w		integer;


BEGIN 
 
select	count(*) 
into STRICT	qt_reg_w 
from	atendimento_paciente 
where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
and	nr_atendimento <> nr_atendimento_p 
and	ie_tipo_atendimento = 1 
and	dt_alta >= (clock_timestamp() - qt_dia_p);
 
if (qt_reg_w >= 1) then 
 
	insert	into comunic_interna( 
		dt_comunicado, 
		ds_titulo, 
		ds_comunicado, 
		nm_usuario, 
		dt_atualizacao, 
		ie_geral, 
		nm_usuario_destino, 
		nr_sequencia, 
		ie_gerencial, 
		nr_seq_classif, 
		ds_perfil_adicional, 
		cd_setor_destino, 
		cd_estab_destino, 
		ds_setor_adicional, 
		dt_liberacao) 
	values (clock_timestamp(), 
		substr(obter_texto_tasy(294579,wheb_usuario_pck.get_nr_seq_idioma),1,255), 
		obter_texto_dic_objeto(294580, wheb_usuario_pck.get_nr_seq_idioma, 'PACIENTE='||obter_nome_pf(cd_pessoa_fisica_p)) || chr(13) || chr(10) || chr(13) || chr(10) || 
		obter_texto_dic_objeto(294581, wheb_usuario_pck.get_nr_seq_idioma, 'NR_ATENDIMENTO='||nr_atendimento_p) || chr(13) || chr(10) || chr(13) || chr(10) || 
		obter_texto_dic_objeto(294582, wheb_usuario_pck.get_nr_seq_idioma, 'QT_DIA='||qt_dia_p), 
		nm_usuario_p, 
		clock_timestamp(), 
		'N', 
		null, 
		nextval('comunic_interna_seq'), 
		'N', 
		null, 
		ds_perfil_p, 
		null, 
		cd_estabelecimento_p, 
		null, 
		clock_timestamp());
 
	commit;
 
	end	if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_reinternacao ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_perfil_p text, qt_dia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

