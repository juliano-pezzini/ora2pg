-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_tabela_param_conv (cd_estabelecimento_p bigint, cd_convenio_p bigint, nm_tabela_p text, nm_seq_visao_p bigint, nm_usuario_p text) AS $body$
DECLARE



nm_atributo_w		varchar(50);
nr_sequencia_w		bigint;
vl_atributo_w		varchar(4000);
ds_comando_w		varchar(255);
vl_default_w		varchar(50);
ds_parametro_w		varchar(255);
ds_atrib_not_w		varchar(4000)	:= 'NR_SEQUENCIA;DT_ATUALIZACA;CD_ESTABELECIMENTO;DT_ATUALIZACAO_NREC;NM_USUARIO_NREC;NM_USUARIO;CD_CONVENIO;';

c01 CURSOR FOR
SELECT	nm_atributo,
	vl_default
from	tabela_atributo
where	nm_tabela		= nm_tabela_p
and	position(nm_atributo  ds_atrib_not_w) = 0
and	ie_tipo_atributo	not in ('FUNCTION','VISUAL');


BEGIN

delete 	from w_tabela_param_convenio
where	nm_usuario	= nm_usuario_p;

select	nextval('w_tabela_param_convenio_seq')
into STRICT	nr_sequencia_w
;

insert into W_TABELA_PARAM_CONVENIO(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nm_tabela,
	cd_convenio_exp)
values (nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nm_tabela_p,
	cd_convenio_p);

open C01;
loop
fetch C01 into
	nm_atributo_w,
	vl_default_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_comando_w		:= 'select '|| nm_atributo_w ||' from '|| nm_tabela_p ||' where cd_estabelecimento = :cd_estab';

	ds_parametro_w		:= 'cd_estab=' || cd_estabelecimento_p;

	if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
		ds_comando_w	:= ds_comando_w|| ' and cd_convenio = :cd_conv';
		ds_parametro_w 	:= ds_parametro_w || ';'||'cd_conv=' || cd_convenio_p;
	end if;

	vl_atributo_w  := obter_valor_dinamico_char_bv( ds_comando_w, ds_parametro_w, vl_atributo_w );

	vl_atributo_w	:= TISS_ELIMINAR_CARACTERE(vl_atributo_w);
	vl_atributo_w	:= Elimina_Acentos(vl_atributo_w);
	vl_atributo_w	:= replace(replace(vl_atributo_w,chr(13),' '),chr(10),' ');

	--vl_atributo_w	:= nvl(vl_atributo_w,vl_default_w);
	insert	into w_tabela_atrib_param_conv(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_tabela,
		nm_atributo,
		vl_atributo)
	values (nextval('w_tabela_atrib_param_conv_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_w,
		nm_atributo_w,
		vl_atributo_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_tabela_param_conv (cd_estabelecimento_p bigint, cd_convenio_p bigint, nm_tabela_p text, nm_seq_visao_p bigint, nm_usuario_p text) FROM PUBLIC;
