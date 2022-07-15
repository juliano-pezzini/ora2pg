-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_tempo_senha ( cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, nr_fila_p text, nr_senha_p text, cd_tempo_p text, dt_tempo_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_fila_w		varchar(20);
nr_atendimento_w	bigint;
nr_sequencia_w	bigint;


BEGIN

nr_fila_w	:= nr_fila_p;
/* Elemar - 13/09/07 - OS65856
nr_fila_w	:= null;
if	(ie_porta_p is not null) then
	nr_fila_w := ie_porta_p || '|';
end if;
if	(nr_fila_p is not null) then
	nr_fila_w := nr_fila_w || nr_fila_p;
end if;
*/
select	coalesce(max(nr_atendimento),null)
into STRICT	nr_atendimento_w
from	tempo_senha_atend
where	trunc(dt_tempo)		= trunc(dt_tempo_p)
  and	nr_fila			= nr_fila_w
  and	nr_senha		= nr_senha_p
  and	ie_tipo_atendimento	= ie_tipo_atendimento_p;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	select	nextval('tempo_senha_atend_seq')
	into STRICT	nr_sequencia_w
	;

	insert into tempo_senha_atend(	nr_sequencia, 	cd_estabelecimento,
					nr_fila,		nr_senha,
					cd_tempo,		dt_tempo,
					dt_atualizacao,	nm_usuario,
					dt_atualizacao_nrec,	nm_usuario_nrec,
					nr_atendimento,	ie_tipo_atendimento)
				values (	nr_sequencia_w,	cd_estabelecimento_p,
					nr_fila_p,		nr_senha_p,
					cd_tempo_p,		dt_tempo_p,
					clock_timestamp(),		nm_usuario_p,
					clock_timestamp(),		nm_usuario_p,
					nr_atendimento_w,	ie_tipo_atendimento_p);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_tempo_senha ( cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, nr_fila_p text, nr_senha_p text, cd_tempo_p text, dt_tempo_p timestamp, nm_usuario_p text) FROM PUBLIC;

