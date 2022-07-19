-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE responder_comunicacao_interna (nr_seq_origem_p bigint, ie_tipo_resposta_p text, nm_usuario_p text, nr_seq_comunic_p INOUT bigint, ie_mensagem_original_p text) AS $body$
DECLARE


nr_seq_comunic_w		bigint;
ds_titulo_w				varchar(255);
ds_comunic_w			varchar(4000);
nm_usuario_origem_w		varchar(15);
ie_geral_w				varchar(01);
cd_perfil_w				integer;
ie_gerencial_w			varchar(01);
nr_seq_classif_w		bigint;
ds_perfil_adicional_w	varchar(4000);
cd_setor_destino_w		integer;
cd_estab_destino_w		smallint;
ds_setor_adicional_w	varchar(2000);
nm_usuario_dest_comun_w	varchar(2000);
nm_usuario_destino_w	varchar(2000) := '';
ds_grupo_w				varchar(255) := '';


BEGIN

select	ds_titulo,
	nm_usuario,
	ie_geral,
	cd_perfil,
	ie_gerencial,
	nr_seq_classif,
	ds_perfil_adicional,
	cd_setor_destino,
	cd_estab_destino,
	ds_setor_adicional,
	nm_usuario_destino,
	ds_grupo
into STRICT	ds_titulo_w,
	nm_usuario_origem_w,
	ie_geral_w,
	cd_perfil_w,
	ie_gerencial_w,
	nr_seq_classif_w,
	ds_perfil_adicional_w,
	cd_setor_destino_w,
	cd_estab_destino_w,
	ds_setor_adicional_w,
	nm_usuario_dest_comun_w,
	ds_grupo_w
from	comunic_interna
where	nr_sequencia	= nr_seq_origem_p;

if (ie_mensagem_original_p = 'N') then
	ds_comunic_w := ' ';
else
	begin
	select	ds_comunicado
	into STRICT	ds_comunic_w
	from	comunic_interna
	where	nr_sequencia	= nr_seq_origem_p;
	exception
		when others then
			ds_comunic_w := obter_desc_expressao(341897);--'Mensagem original muito extensa. Não pode ser copiada';
	end;
end if;

select	nextval('comunic_interna_seq')
into STRICT	nr_seq_comunic_w
;

if (ie_tipo_resposta_p	= 'U') then
	begin
	nm_usuario_destino_w	:= nm_usuario_origem_w;
	ds_setor_adicional_w	:= '';
	ds_perfil_adicional_w	:= '';
	ie_geral_w		:= 'N';
	end;
else
	nm_usuario_destino_w	:= replace(nm_usuario_dest_comun_w, nm_usuario_p, nm_usuario_origem_w);
end if;

insert	into comunic_interna(dt_comunicado,
	ds_titulo,
	ds_comunicado,
	nm_usuario,
	dt_atualizacao,
	ie_geral,
	nm_usuario_destino,
	cd_perfil,
	nr_sequencia,
	ie_gerencial,
	nr_seq_classif,
	ds_perfil_adicional,
	cd_setor_destino,
	cd_estab_destino,
	ds_setor_adicional,
	ds_grupo) -- Francisco - 09/04/07 - OS 52627 - Inclui o grupo
values (clock_timestamp(),
	substr('RE: '|| ds_titulo_w,1,254),
	ds_comunic_w,
	nm_usuario_p,
	clock_timestamp(),
	ie_geral_w,
	substr(nm_usuario_destino_w,1,255),
	cd_perfil_w,
	nr_seq_comunic_w,
	ie_gerencial_w,
	nr_seq_classif_w,
	ds_perfil_adicional_w,
	cd_setor_destino_w,
	cd_estab_destino_w,
	ds_setor_adicional_w,
	ds_grupo_w);

nr_seq_comunic_p	:= nr_seq_comunic_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE responder_comunicacao_interna (nr_seq_origem_p bigint, ie_tipo_resposta_p text, nm_usuario_p text, nr_seq_comunic_p INOUT bigint, ie_mensagem_original_p text) FROM PUBLIC;

