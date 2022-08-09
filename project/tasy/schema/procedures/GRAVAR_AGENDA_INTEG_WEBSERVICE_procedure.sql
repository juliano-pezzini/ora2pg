-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_agenda_integ_webservice ( nr_seq_evento_p bigint, nr_documento_p bigint, ie_tipo_documento_p text, cd_setor_atendimento_p bigint default null) AS $body$
DECLARE


jobno				bigint;
cd_estabelecimento_w		smallint;
ds_parametros_w			varchar(4000);
ds_parametros_ww			varchar(4000);
cd_setor_atendimento_w		varchar(60);


BEGIN

if (wheb_usuario_pck.is_evento_ativo(nr_seq_evento_p) = 'S') then
	begin

	if (ie_tipo_documento_p = 'C') then

		select	cd_estabelecimento
		into STRICT	cd_estabelecimento_w
		from	cot_compra
		where	nr_cot_compra = nr_documento_p;

		ds_parametros_w	:=	'nr_cot_compra=' || nr_documento_p || ';';

	end if;

	cd_setor_atendimento_w := '';
	if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
		cd_setor_atendimento_w := ', ' ||cd_setor_atendimento_p;
	end if;

	select	ds_parametros_w ||
		'pck_cd_estabelecimento=' || cd_estabelecimento_w || obter_separador_bv  ||
		'pck_nm_usuario=WebService' || obter_separador_bv
	into STRICT	ds_parametros_ww
	;

	dbms_job.submit(jobno,'job_gravar_agend_integracao('|| to_char(nr_seq_evento_p) || ', ''' || ds_parametros_ww || ''', ' || cd_estabelecimento_w || cd_setor_atendimento_w || ');');

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_agenda_integ_webservice ( nr_seq_evento_p bigint, nr_documento_p bigint, ie_tipo_documento_p text, cd_setor_atendimento_p bigint default null) FROM PUBLIC;
