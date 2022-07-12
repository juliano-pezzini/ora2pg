-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_glosa_acao_ptu ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_complemento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_inconsistencia_w				smallint;

ie_tipo_transacao_w				varchar(2);
ie_retorno_w					varchar(2)	:= 'N';

nr_seq_motivo_glosa_w				bigint;
nr_seq_procedimento_w				bigint;
nr_seq_material_w				bigint;
nr_seq_inconsist_w				bigint;

C01 CURSOR FOR
	SELECT	nr_seq_motivo_glosa
	from	pls_guia_glosa
	where	nr_seq_guia		= nr_seq_guia_p
	and	ie_tipo_transacao_w	= 'G'
	
union

	SELECT	nr_seq_motivo_glosa
	from	pls_requisicao_glosa
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	ie_tipo_transacao_w	= 'R';

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_proc
	where	nr_seq_guia		= nr_seq_guia_p
	and (nr_seq_compl_ptu	= nr_seq_complemento_p	or coalesce(nr_seq_complemento_p::text, '') = '')
	
union

	SELECT	nr_sequencia
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and (nr_seq_compl_ptu	= nr_seq_complemento_p	or coalesce(nr_seq_complemento_p::text, '') = '');

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_mat
	where	nr_seq_guia		= nr_seq_guia_p
	and (nr_seq_compl_ptu	= nr_seq_complemento_p	or coalesce(nr_seq_complemento_p::text, '') = '')
	
union

	SELECT	nr_sequencia
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and (nr_seq_compl_ptu	= nr_seq_complemento_p	or coalesce(nr_seq_complemento_p::text, '') = '');

C04 CURSOR FOR
	SELECT	nr_seq_motivo_glosa
	from	pls_guia_glosa
	where (nr_seq_guia_proc	= nr_seq_procedimento_w or coalesce(nr_seq_procedimento_w::text, '') = '')
	and (nr_seq_guia_mat	= nr_seq_material_w 	or coalesce(nr_seq_material_w::text, '') = '')
	and	ie_tipo_transacao_w	= 'G'
	
union

	SELECT	nr_seq_motivo_glosa
	from	pls_requisicao_glosa
	where (nr_seq_req_proc	= nr_seq_procedimento_w or coalesce(nr_seq_procedimento_w::text, '') = '')
	and (nr_seq_req_mat		= nr_seq_material_w 	or coalesce(nr_seq_material_w::text, '') = '')
	and	ie_tipo_transacao_w	= 'R';

C05 CURSOR FOR
	SELECT	a.nr_seq_inconsistencia
	from	ptu_intercambio_consist a
	where	((nr_seq_requisicao	= nr_seq_requisicao_p or coalesce(nr_seq_requisicao::text, '') = '')
	and	((nr_seq_procedimento	= nr_seq_procedimento_w and (nr_seq_procedimento IS NOT NULL AND nr_seq_procedimento::text <> '')) or (coalesce(nr_seq_procedimento_w::text, '') = '' and coalesce(nr_seq_procedimento::text, '') = ''))
	and	((nr_seq_material	= nr_seq_material_w and (nr_seq_material IS NOT NULL AND nr_seq_material::text <> '')) or (coalesce(nr_seq_material_w::text, '') = '' and coalesce(nr_seq_material::text, '') = '')))
	
union

	SELECT	y.nr_sequencia
	from	pls_acao_glosa_tiss	x,
		ptu_inconsistencia	y,
		pls_requisicao_glosa	z
	where	x.nr_seq_inconsis_scs	= y.nr_sequencia
	and	x.nr_seq_motivo_glosa	= z.nr_seq_motivo_glosa
	and	((z.nr_seq_requisicao	= nr_seq_requisicao_p or coalesce(z.nr_seq_requisicao::text, '') = '')
	and	((z.nr_seq_req_proc	= nr_seq_procedimento_w and (z.nr_seq_req_proc IS NOT NULL AND z.nr_seq_req_proc::text <> '')) or (coalesce(nr_seq_procedimento_w::text, '') = '' and coalesce(z.nr_seq_req_proc::text, '') = ''))
	and	((z.nr_seq_req_mat	= nr_seq_material_w and (z.nr_seq_req_mat IS NOT NULL AND z.nr_seq_req_mat::text <> '')) or (coalesce(nr_seq_material_w::text, '') = '' and coalesce(z.nr_seq_req_mat::text, '') = '')))
	
union

	select	v.nr_sequencia
	from	pls_ocorrencia_scs	u,
		ptu_inconsistencia	v,
		pls_ocorrencia_benef	w
	where	u.nr_seq_inconsis_scs	= v.nr_sequencia
	and	u.nr_seq_ocorrencia	= w.nr_seq_ocorrencia
	and	((w.nr_seq_requisicao	= nr_seq_requisicao_p or coalesce(w.nr_seq_requisicao::text, '') = '')
	and	((w.nr_seq_proc	= nr_seq_procedimento_w and (w.nr_seq_proc IS NOT NULL AND w.nr_seq_proc::text <> '')) or (coalesce(nr_seq_procedimento_w::text, '') = '' and coalesce(w.nr_seq_proc::text, '') = ''))
	and	((w.nr_seq_mat	= nr_seq_material_w and (w.nr_seq_mat IS NOT NULL AND w.nr_seq_mat::text <> '')) or (coalesce(nr_seq_material_w::text, '') = '' and coalesce(w.nr_seq_mat::text, '') = '')));


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	ie_tipo_transacao_w	:= 'G';
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	ie_tipo_transacao_w	:= 'R';
end if;

open C01;
loop
fetch C01 into
	nr_seq_motivo_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	begin
	select	b.cd_inconsistencia
	into STRICT	cd_inconsistencia_w
	from	pls_acao_glosa_tiss	a,
		ptu_inconsistencia	b
	where	a.nr_seq_inconsis_scs	= b.nr_sequencia
	and	a.nr_seq_motivo_glosa	= nr_seq_motivo_glosa_w;
	exception
	when others then
		cd_inconsistencia_w	:= 0;
	end;

	if (coalesce(cd_inconsistencia_w,0)	<> 0) then
		ie_retorno_w	:= 'S';
	end if;

	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	open C04;
	loop
	fetch C04 into
		nr_seq_motivo_glosa_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		begin
			select	b.cd_inconsistencia
			into STRICT	cd_inconsistencia_w
			from	pls_acao_glosa_tiss	a,
				ptu_inconsistencia	b
			where	a.nr_seq_inconsis_scs	= b.nr_sequencia
			and	a.nr_seq_motivo_glosa	= nr_seq_motivo_glosa_w;
		exception
		when others then
			cd_inconsistencia_w	:= 0;
		end;

		if (coalesce(cd_inconsistencia_w,0)	<> 0) then
			ie_retorno_w	:= 'S';
		end if;
		end;
	end loop;
	close C04;
	end;

	if (ie_retorno_w	= 'N') then
		open C05;
		loop
		fetch C05 into
			nr_seq_inconsist_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			begin
				select	cd_inconsistencia
				into STRICT	cd_inconsistencia_w
				from	ptu_inconsistencia
				where	nr_sequencia	= nr_seq_inconsist_w;
			exception
			when others then
				cd_inconsistencia_w	:= 0;
			end;

			if (coalesce(cd_inconsistencia_w,0)	<> 0) then
				ie_retorno_w	:= 'S';
			end if;
			end;
		end loop;
		close C05;
	end if;
end loop;
close C02;

open C03;
loop
fetch C03 into
	nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	open C04;
	loop
	fetch C04 into
		nr_seq_motivo_glosa_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		begin
			select	b.cd_inconsistencia
			into STRICT	cd_inconsistencia_w
			from	pls_acao_glosa_tiss	a,
				ptu_inconsistencia	b
			where	a.nr_seq_inconsis_scs	= b.nr_sequencia
			and	a.nr_seq_motivo_glosa	= nr_seq_motivo_glosa_w;
		exception
		when others then
			cd_inconsistencia_w	:= 0;
		end;

		if (coalesce(cd_inconsistencia_w,0)	<> 0) then
			ie_retorno_w	:= 'S';
		end if;
		end;
	end loop;
	close C04;

	if (ie_retorno_w	= 'N') then
		open C05;
		loop
		fetch C05 into
			nr_seq_inconsist_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			begin
				select	cd_inconsistencia
				into STRICT	cd_inconsistencia_w
				from	ptu_inconsistencia
				where	nr_sequencia	= nr_seq_inconsist_w;
			exception
			when others then
				cd_inconsistencia_w	:= 0;
			end;

			if (coalesce(cd_inconsistencia_w,0)	<> 0) then
				ie_retorno_w	:= 'S';
			end if;
			end;
		end loop;
		close C05;
	end if;
	end;
end loop;
close C03;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_glosa_acao_ptu ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_complemento_p bigint) FROM PUBLIC;

