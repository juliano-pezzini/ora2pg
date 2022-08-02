-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inativar_usuario_eventual ( nr_seq_segurado_p bigint, nr_seq_motivo_p bigint, dt_rescisao_p timestamp, ds_observacao_p text, nm_usuario_p text, dt_limite_utilizacao_p timestamp) AS $body$
DECLARE


ie_situacao_atend_w	varchar(1);


BEGIN

if (dt_limite_utilizacao_p > clock_timestamp()) then
	ie_situacao_atend_w	:= 'A';
elsif (dt_limite_utilizacao_p <= clock_timestamp()) then
	ie_situacao_atend_w	:= 'I';
end if;

update	pls_segurado
set	dt_rescisao			= dt_rescisao_p,
	nm_usuario			= nm_usuario_p,
	dt_atualizacao			= clock_timestamp(),
	nr_seq_motivo_cancelamento 	= nr_seq_motivo_p,
	dt_limite_utilizacao		= dt_limite_utilizacao_p,
	ie_situacao_atend		= ie_situacao_atend_w
where	nr_sequencia	= nr_seq_segurado_p;
		
CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '45', dt_rescisao_p, 'Rescisão',
				ds_observacao_p, null, null, null,
				nr_seq_motivo_p, dt_rescisao_p, null, null,
				null, null, null, null,
				nm_usuario_p, 'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inativar_usuario_eventual ( nr_seq_segurado_p bigint, nr_seq_motivo_p bigint, dt_rescisao_p timestamp, ds_observacao_p text, nm_usuario_p text, dt_limite_utilizacao_p timestamp) FROM PUBLIC;

