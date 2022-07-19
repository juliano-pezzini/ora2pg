-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_enviar_comunic_interna ( nr_seq_projeto_p text, ie_setor_avisar_p text, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


ds_titulo_w		varchar(100);
ds_comunicacao_w		varchar(255);

cd_perfil_w		bigint := '';
nr_sequencia_w		bigint;

nr_seq_classif_w		varchar(10);
nm_usuario_destino_w	varchar(255) := '';

/* Se tiver setor na regra, envia CI para os setores */

ds_setor_adicional_w	varchar(2000) := '';


BEGIN

select	obter_classif_comunic('F')
into STRICT	nr_seq_classif_w
;

if (ie_setor_avisar_p = 'M') then
	ds_setor_adicional_w := '120,';
elsif (ie_setor_avisar_p = 'T') then
	ds_setor_adicional_w := '79294,';
end if;

ds_titulo_w	 := 'Liberação da ficha de projeto';
ds_comunicacao_w := 'Liberada a ficha do projeto ' || nr_seq_projeto_p;

select	nextval('comunic_interna_seq')
into STRICT	nr_sequencia_w
;

insert into comunic_interna(
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
		dt_liberacao,
		ds_perfil_adicional,
		ds_setor_adicional)
values (		clock_timestamp(),
		ds_titulo_w,
		ds_comunicacao_w,
		nm_usuario_p,
		clock_timestamp(),
		'N',
		nm_usuario_destino_w,
		nr_sequencia_w,
		'N',
		nr_seq_classif_w,
		clock_timestamp(),
		cd_perfil_w,
		ds_setor_adicional_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_enviar_comunic_interna ( nr_seq_projeto_p text, ie_setor_avisar_p text, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

