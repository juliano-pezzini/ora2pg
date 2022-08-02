-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocorr_glosa_aud_aut ( nr_seq_auditoria_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_guia_w			bigint;
nr_seq_requisicao_w		bigint;
nr_seq_execucao_w		bigint;
nr_seq_proc_origem_w		bigint;
nr_seq_mat_origem_w		bigint;
nr_seq_proc_w 			bigint := 0;
nr_seq_mat_w			bigint := 0;
nr_seq_glosa_w			bigint;
nr_seq_aud_item_w		bigint;
nr_seq_ocorr_benef_w		bigint;
ie_tipo_w			varchar(10);
nr_nivel_liberacao_w		smallint;
nr_seq_ocorrencia_w		bigint;
ie_auditoria_w			varchar(1);
nr_seq_motivo_glosa_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_proc_origem,
		nr_seq_mat_origem
	from	pls_auditoria_item
	where	nr_seq_auditoria = nr_seq_auditoria_p
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	ie_tipo,
		nr_seq_glosa,
		nr_seq_ocorr_benef,
		nr_nivel_liberacao,
		nr_seq_ocorrencia
	from	(SELECT	'G' ie_tipo,
			nr_sequencia nr_seq_glosa,
			null nr_seq_ocorr_benef,
			nr_seq_ocorrencia nr_ocorrencia,
			nr_seq_guia nr_seq_guia,
			nr_seq_guia_proc nr_seq_proc,
			nr_seq_guia_mat nr_seq_mat,
			0 nr_nivel_liberacao,
			null nr_seq_ocorrencia
		from	pls_guia_glosa
		where	((nr_seq_guia		= nr_seq_guia_w)
		or (nr_seq_guia_proc	= nr_seq_proc_w)
		or (nr_seq_guia_mat	= nr_seq_mat_w))
		
union

		select	'O' ie_tipo,
			null nr_seq_glosa,
			nr_sequencia nr_seq_ocorr_benef,
			null nr_ocorrencia,
			nr_seq_guia_plano nr_seq_guia,
			nr_seq_proc nr_seq_proc,
			nr_seq_mat nr_seq_mat,
			nr_nivel_liberacao,
			nr_seq_ocorrencia
		from	pls_ocorrencia_benef
		where	coalesce(nr_seq_conta::text, '') = ''
		and	coalesce(nr_seq_requisicao::text, '') = ''
		and	coalesce(nr_seq_execucao::text, '') = ''
		and	nr_seq_guia_plano	= nr_seq_guia_w
		and	((nr_seq_proc		= nr_seq_proc_w)
		or (nr_seq_mat		= nr_seq_mat_w)
		or	((coalesce(nr_seq_proc::text, '') = '')
		and (coalesce(nr_seq_mat::text, '') = '')))) alias15
	where (nr_seq_guia	= nr_seq_guia_w	or coalesce(nr_seq_guia::text, '') = '')
	and	((nr_seq_proc	= nr_seq_proc_w	and (nr_seq_proc IS NOT NULL AND nr_seq_proc::text <> '')) or (nr_seq_proc_w	= 0 and coalesce(nr_seq_proc::text, '') = ''))
	and	((nr_seq_mat	= nr_seq_mat_w	and (nr_seq_mat IS NOT NULL AND nr_seq_mat::text <> '')) or (nr_seq_mat_w	= 0 and coalesce(nr_seq_mat::text, '') = ''));


BEGIN

select	nr_seq_guia,
	nr_seq_requisicao,
	nr_seq_execucao
into STRICT	nr_seq_guia_w,
	nr_seq_requisicao_w,
	nr_seq_execucao_w
from	pls_auditoria
where	nr_sequencia = nr_seq_auditoria_p;

open C02;
loop
fetch C02 into
	ie_tipo_w,
	nr_seq_glosa_w,
	nr_seq_ocorr_benef_w,
	nr_nivel_liberacao_w,
	nr_seq_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ie_auditoria_w	:= 'N';
	begin
		select	ie_auditoria,
			nr_seq_motivo_glosa
		into STRICT	ie_auditoria_w,
			nr_seq_motivo_glosa_w
		from	pls_ocorrencia
		where	nr_sequencia	= nr_seq_ocorrencia_w;
	exception
	when others then
		ie_auditoria_w	:= 'N';
	end;

	if	((ie_auditoria_w	= 'S') or ((ie_auditoria_w	= 'N')	and ((nr_seq_motivo_glosa_w IS NOT NULL AND nr_seq_motivo_glosa_w::text <> '') or (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '')))) then
		nr_nivel_liberacao_w := coalesce(nr_nivel_liberacao_w,0);

		insert into pls_analise_ocor_glosa_aut(nr_sequencia, ie_status, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			nr_seq_auditoria, nr_seq_aud_item, nr_seq_glosa,
			nr_seq_ocorrencia_benef, ie_tipo, nr_nivel_liberacao,
			nr_seq_ocorrencia)
		values (nextval('pls_analise_ocor_glosa_aut_seq'), 'P', clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			nr_seq_auditoria_p, null, nr_seq_glosa_w,
			nr_seq_ocorr_benef_w, ie_tipo_w, nr_nivel_liberacao_w,
			nr_seq_ocorrencia_w);

	elsif (ie_auditoria_w	= 'N') then
		nr_nivel_liberacao_w := coalesce(nr_nivel_liberacao_w,0);

		insert into pls_analise_ocor_glosa_aut(nr_sequencia, ie_status, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			nr_seq_auditoria, nr_seq_aud_item, nr_seq_glosa,
			nr_seq_ocorrencia_benef, ie_tipo, nr_nivel_liberacao,
			nr_seq_ocorrencia)
		values (nextval('pls_analise_ocor_glosa_aut_seq'), 'L', clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			nr_seq_auditoria_p, null, nr_seq_glosa_w,
			nr_seq_ocorr_benef_w, ie_tipo_w, nr_nivel_liberacao_w,
			nr_seq_ocorrencia_w);

	end if;
	end;
end loop;
close C02;

open C01;
loop
fetch C01 into
	nr_seq_aud_item_w,
	nr_seq_proc_origem_w,
	nr_seq_mat_origem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(nr_seq_proc_origem_w,0) > 0) then
		nr_seq_proc_w := nr_seq_proc_origem_w;
		nr_seq_mat_w := 0;

	elsif (coalesce(nr_seq_mat_origem_w,0) > 0) then
		nr_seq_mat_w := nr_seq_mat_origem_w;
		nr_seq_proc_w := 0;

	end if;

	open C02;
	loop
	fetch C02 into
		ie_tipo_w,
		nr_seq_glosa_w,
		nr_seq_ocorr_benef_w,
		nr_nivel_liberacao_w,
		nr_seq_ocorrencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_auditoria_w	:= 'N';
		begin
			select	ie_auditoria,
				nr_seq_motivo_glosa
			into STRICT	ie_auditoria_w,
				nr_seq_motivo_glosa_w
			from	pls_ocorrencia
			where	nr_sequencia	= nr_seq_ocorrencia_w;
		exception
		when others then
			ie_auditoria_w	:= 'N';
		end;

		if	((ie_auditoria_w	= 'S') or ((ie_auditoria_w	= 'N')	and ((nr_seq_motivo_glosa_w IS NOT NULL AND nr_seq_motivo_glosa_w::text <> '') or (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '')))) then
			nr_nivel_liberacao_w := coalesce(nr_nivel_liberacao_w,0);

			insert into pls_analise_ocor_glosa_aut(nr_sequencia, ie_status, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_auditoria, nr_seq_aud_item, nr_seq_glosa,
				nr_seq_ocorrencia_benef, ie_tipo, nr_nivel_liberacao,
				nr_seq_ocorrencia)
			values (nextval('pls_analise_ocor_glosa_aut_seq'), 'P', clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_auditoria_p, nr_seq_aud_item_w, nr_seq_glosa_w,
				nr_seq_ocorr_benef_w, ie_tipo_w, nr_nivel_liberacao_w,
				nr_seq_ocorrencia_w);

		elsif (ie_auditoria_w = 	'N') then
			nr_nivel_liberacao_w := coalesce(nr_nivel_liberacao_w,0);

			insert into pls_analise_ocor_glosa_aut(nr_sequencia, ie_status, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_auditoria, nr_seq_aud_item, nr_seq_glosa,
				nr_seq_ocorrencia_benef, ie_tipo, nr_nivel_liberacao,
				nr_seq_ocorrencia)
			values (nextval('pls_analise_ocor_glosa_aut_seq'), 'L', clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_auditoria_p, nr_seq_aud_item_w, nr_seq_glosa_w,
				nr_seq_ocorr_benef_w, ie_tipo_w, nr_nivel_liberacao_w,
				nr_seq_ocorrencia_w);

		end if;
		end;
	end loop;
	close C02;

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_ocorr_glosa_aud_aut ( nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;

