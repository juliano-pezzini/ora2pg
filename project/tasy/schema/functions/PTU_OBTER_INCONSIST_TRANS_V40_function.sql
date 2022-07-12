-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_inconsist_trans_v40 ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_consulta_p bigint, cd_transacao_p text, nr_qt_reg_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter inconsistências trans_v40.

ROTINA UTILIZADA NAS TRANSAÇÕES PTU VIA SCS HOMOLOGADAS COM A UNIMED BRASIL.
QUANDO FOR ALTERAR, FAVOR VERIFICAR COM O ANÁLISTA RESPONSÁVEL PARA A REALIZAÇÃO DE TESTES.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_inconsistencia_w		smallint	:= 0;
qt_registro_w			smallint;
nr_seq_inconsist_w		bigint;
count_registro_w		bigint := 1;
ie_tipo_w			varchar(2);
nr_seq_servico_w		bigint := 0;

C01 CURSOR FOR
	SELECT	distinct(nr_seq_inconsistencia)
	from	ptu_intercambio_consist
	where (nr_seq_guia		= nr_seq_guia_p 	or coalesce(nr_seq_guia_p::text, '') = '')
	and (nr_seq_requisicao	= nr_seq_requisicao_p	or coalesce(nr_seq_requisicao_p::text, '') = '')
	and (nr_seq_procedimento	= nr_seq_proc_p 	or coalesce(nr_seq_proc_p::text, '') = '')
	and (ie_tipo_w		= 'P'			or coalesce(ie_tipo_w::text, '') = '')
	and	cd_transacao		= cd_transacao_p
	and	((exists (	SELECT	1
				from	pls_requisicao_proc	x
				where	x.ie_status	in ('N','G')
				and	x.nr_sequencia	= nr_seq_proc_p)
	or	not exists (	select	1
				from	pls_requisicao_proc	y
				where	y.nr_sequencia	= nr_seq_proc_p))
	or (exists (	select	1
				from	pls_guia_plano_proc	w
				where	w.ie_status	in ('N','M','K')
				and	w.nr_sequencia	= nr_seq_proc_p)
	or	not exists (	select	1
				from	pls_guia_plano_proc	z
				where	z.nr_sequencia	= nr_seq_proc_p)));

C02 CURSOR FOR
	SELECT	distinct(nr_seq_inconsistencia)
	from	ptu_intercambio_consist
	where (nr_seq_guia		= nr_seq_guia_p 	or coalesce(nr_seq_guia_p::text, '') = '')
	and (nr_seq_requisicao	= nr_seq_requisicao_p	or coalesce(nr_seq_requisicao_p::text, '') = '')
	and (nr_seq_material	= nr_seq_mat_p 		or coalesce(nr_seq_mat_p::text, '') = '')
	and (ie_tipo_w		= 'M'			or coalesce(ie_tipo_w::text, '') = '')
	and	cd_transacao		= cd_transacao_p
	and	((exists (	SELECT	1
				from	pls_requisicao_mat	x
				where	x.ie_status	in ('N','G')
				and	x.nr_sequencia	= nr_seq_mat_p)
	or	not exists (	select	1
				from	pls_requisicao_mat	y
				where	y.nr_sequencia	= nr_seq_mat_p))
	or (exists (	select	1
				from	pls_guia_plano_mat	w
				where	w.ie_status	in ('N','M','K')
				and	w.nr_sequencia	= nr_seq_mat_p)
	or	not exists (	select	1
				from	pls_guia_plano_mat	z
				where	z.nr_sequencia	= nr_seq_mat_p)));

C03 CURSOR FOR
	SELECT	distinct(nr_seq_inconsistencia)
	from	ptu_intercambio_consist
	where	((nr_seq_consulta_benef	= nr_seq_consulta_p)
	or (nr_seq_consulta_prest	= nr_seq_consulta_p))
	and	cd_transacao		= cd_transacao_p;

C04 CURSOR FOR
	SELECT	distinct(nr_seq_inconsistencia)
	from	ptu_intercambio_consist
	where (nr_seq_guia		= nr_seq_guia_p 	or coalesce(nr_seq_guia_p::text, '') = '')
	and (nr_seq_requisicao	= nr_seq_requisicao_p	or coalesce(nr_seq_requisicao_p::text, '') = '')
	and (nr_seq_procedimento	= nr_seq_consulta_p 	or coalesce(nr_seq_consulta_p::text, '') = '')
	and	cd_transacao		= cd_transacao_p;


BEGIN

if (coalesce(nr_seq_consulta_p,0)	= 0) then
	if (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
		ie_tipo_w	:= 'P';
	else
		ie_tipo_w	:= 'M';
	end if;

	open C01;
	loop
	fetch C01 into
		nr_seq_inconsist_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		cd_inconsistencia_w	:= 0;

		select	count(distinct(nr_seq_inconsistencia))
		into STRICT	qt_registro_w
		from	ptu_intercambio_consist
		where (nr_seq_guia		= nr_seq_guia_p 	or coalesce(nr_seq_guia_p::text, '') = '')
		and (nr_seq_requisicao	= nr_seq_requisicao_p	or coalesce(nr_seq_requisicao_p::text, '') = '')
		and (nr_seq_procedimento	= nr_seq_proc_p 	or coalesce(nr_seq_proc_p::text, '') = '')
		and (ie_tipo_w		= 'P'			or coalesce(ie_tipo_w::text, '') = '')
		and	cd_transacao		= cd_transacao_p;

		select	max(cd_inconsistencia)
		into STRICT	cd_inconsistencia_w
		from	ptu_inconsistencia
		where	nr_sequencia	= nr_seq_inconsist_w;

		if (nr_qt_reg_p	<= qt_registro_w) then
			if (count_registro_w  =  nr_qt_reg_p) then
				return	cd_inconsistencia_w;
			else
				count_registro_w := count_registro_w  + 1;
			end if;
		else
			cd_inconsistencia_w	:= 0;
		end if;
		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		nr_seq_inconsist_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	count(distinct(nr_seq_inconsistencia))
		into STRICT	qt_registro_w
		from	ptu_intercambio_consist
		where (nr_seq_guia		= nr_seq_guia_p 	or coalesce(nr_seq_guia_p::text, '') = '')
		and (nr_seq_requisicao	= nr_seq_requisicao_p	or coalesce(nr_seq_requisicao_p::text, '') = '')
		and (nr_seq_material	= nr_seq_mat_p 		or coalesce(nr_seq_mat_p::text, '') = '')
		and (ie_tipo_w		= 'M'			or coalesce(ie_tipo_w::text, '') = '')
		and	cd_transacao		= cd_transacao_p;

		select	max(cd_inconsistencia)
		into STRICT	cd_inconsistencia_w
		from	ptu_inconsistencia
		where	nr_sequencia	= nr_seq_inconsist_w;

		if (nr_qt_reg_p	<= qt_registro_w) then
			if (count_registro_w  =  nr_qt_reg_p) then
				return	cd_inconsistencia_w;
			else
				count_registro_w 	:= count_registro_w  + 1;
			end if;
		else
			cd_inconsistencia_w	:= 0;
		end if;
		end;
	end loop;
	close C02;
elsif (cd_transacao_p	= '00361') then
	open C04;
	loop
	fetch C04 into
		nr_seq_inconsist_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		select	count(distinct(nr_seq_inconsistencia))
		into STRICT	qt_registro_w
		from	ptu_intercambio_consist
		where (nr_seq_guia		= nr_seq_guia_p 	or coalesce(nr_seq_guia_p::text, '') = '')
		and (nr_seq_requisicao	= nr_seq_requisicao_p	or coalesce(nr_seq_requisicao_p::text, '') = '')
		and (nr_seq_procedimento	= nr_seq_consulta_p 	or coalesce(nr_seq_consulta_p::text, '') = '')
		and	cd_transacao		= cd_transacao_p;

		select	max(cd_inconsistencia)
		into STRICT	cd_inconsistencia_w
		from	ptu_inconsistencia
		where	nr_sequencia	= nr_seq_inconsist_w;

		if (nr_qt_reg_p	<= qt_registro_w) then
			if (count_registro_w  =  nr_qt_reg_p) then
				return	cd_inconsistencia_w;
			else
				count_registro_w := count_registro_w  + 1;
			end if;
		else
			cd_inconsistencia_w	:= 0;
		end if;
		end;
	end loop;
	close C04;
else
	open C03;
	loop
	fetch C03 into
		nr_seq_inconsist_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		select	count(distinct(nr_seq_inconsistencia))
		into STRICT	qt_registro_w
		from	ptu_intercambio_consist
		where	((nr_seq_consulta_benef	= nr_seq_consulta_p)
		or (nr_seq_consulta_prest	= nr_seq_consulta_p))
		and	cd_transacao		= cd_transacao_p;

		select	max(cd_inconsistencia)
		into STRICT	cd_inconsistencia_w
		from	ptu_inconsistencia
		where	nr_sequencia	= nr_seq_inconsist_w;

		if (nr_qt_reg_p	<= qt_registro_w) then
			if (count_registro_w  =  nr_qt_reg_p) then
				return	cd_inconsistencia_w;
			else
				count_registro_w := count_registro_w  + 1;
			end if;
		else
			cd_inconsistencia_w	:= 0;
		end if;
		end;
	end loop;
	close C03;
end if;


return	cd_inconsistencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_inconsist_trans_v40 ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_consulta_p bigint, cd_transacao_p text, nr_qt_reg_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint) FROM PUBLIC;
