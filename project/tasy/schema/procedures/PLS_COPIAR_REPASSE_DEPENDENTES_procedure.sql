-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_repasse_dependentes ( nr_seq_seg_repasse_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
nr_seq_titular_w		bigint;
nr_seq_seg_repasse_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_segurado	a
	where	a.nr_seq_titular	= nr_seq_titular_w
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((coalesce(a.dt_rescisao::text, '') = '') or (a.dt_rescisao > clock_timestamp()))
	and	not exists (	SELECT	1
					from	pls_segurado_repasse	x
					where	x.nr_seq_segurado	= a.nr_sequencia
					and	(x.dt_fim_repasse IS NOT NULL AND x.dt_fim_repasse::text <> ''));


BEGIN

select	nr_seq_segurado
into STRICT	nr_seq_titular_w
from	pls_segurado_repasse
where	nr_sequencia	= nr_seq_seg_repasse_p;

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('pls_segurado_repasse_seq')
	into STRICT	nr_seq_seg_repasse_w
	;

	insert into pls_segurado_repasse(		nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			cd_estabelecimento,nr_seq_segurado,nr_seq_congenere,dt_repasse,ie_tipo_repasse,
			nr_seq_plano,ie_cartao_provisorio,nr_seq_motivo_via_adic,nr_seq_congenere_atend,ie_origem_solicitacao,
			ie_tipo_compartilhamento)
	(	SELECT	nr_seq_seg_repasse_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			cd_estabelecimento_p,nr_seq_segurado_w,nr_seq_congenere,dt_repasse,ie_tipo_repasse,
			nr_seq_plano,ie_cartao_provisorio,nr_seq_motivo_via_adic,nr_seq_congenere_atend,'M',
			ie_tipo_compartilhamento
		from	pls_segurado_repasse
		where	nr_sequencia	= nr_seq_seg_repasse_p);

	CALL pls_liberar_repasse_seg(nr_seq_seg_repasse_w,nm_usuario_p,'N');

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_repasse_dependentes ( nr_seq_seg_repasse_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

