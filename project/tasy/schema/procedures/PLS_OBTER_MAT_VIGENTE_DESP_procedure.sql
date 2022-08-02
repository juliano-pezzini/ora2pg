-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_mat_vigente_desp ( nr_seq_material_p INOUT pls_material.nr_sequencia%type, dt_referencia_p timestamp, cd_mat_referencia_w text, ie_opcao_p text, ie_valida_vig_mat_p text, nr_versao_tiss_p pls_material_tiss.ds_versao_tiss%type, ie_tipo_despesa_p pls_material.ie_tipo_despesa%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Aplicar apenas os materiais TISS vigentes

ROTINA UTILIZADA NAS TRANSAÇÕES PTU VIA SCS HOMOLOGADAS COM A UNIMED BRASIL.
QUANDO FOR ALTERAR, FAVOR VERIFICAR COM O ANÁLISTA RESPONSÁVEL PARA A REALIZAÇÃO DE TESTES.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:		IE_OPCAO_P

			O	- Código OPS
			A	- Código A900 (sequencia)
			F	- Código Federação
			AC	- Código A900 (código)
			M	- Código MAT (pls_material)
			S	- Sequencia MAT (pls_material)

			IE_VALIDA_VIG_MAT_P

			S/N	- Valida (ou não) Dt vigencia da PLS_MATERIAL

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/dt_referencia_w		timestamp;
cd_material_ops_w	pls_material.cd_material_ops%type;
cd_material_a900_w	pls_material_unimed.cd_material%type;
cd_material_fed_w	pls_mat_unimed_fed_sc.cd_material%type;
cd_mat_a900_ops_w	pls_material.cd_material_a900%type;
cd_material_w		pls_material.cd_material%type;
nr_seq_material_w	pls_material.nr_sequencia%type;
ie_valida_vig_mat_w	varchar(10);

-- Material com Código OPS
C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_material_tiss	t,
		pls_material		a
	where	a.nr_sequencia		= t.nr_seq_material
	and	a.cd_material_ops_number = cd_material_ops_w
	and	t.ds_versao_tiss	= nr_versao_tiss_p
	and	dt_referencia_w between t.dt_inicio_vigencia_ref and t.dt_fim_vigencia_ref
	and	a.ie_tipo_despesa	= ie_tipo_despesa_p
	and (ie_valida_vig_mat_w	= 'N'
		or (a.ie_situacao	= 'A'
		and	dt_referencia_w between a.dt_inclusao_ref and a.dt_fim_vigencia_ref))
	order by t.dt_inicio_vigencia_ref;

-- Material com Código A900 (integridade de sequencia)
C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_material_tiss	t,
		pls_material_unimed	u,
		pls_material		a
	where	a.nr_sequencia		= t.nr_seq_material
	and	u.nr_sequencia		= a.nr_seq_material_unimed
	and	u.cd_material		= cd_material_a900_w
	and	t.ds_versao_tiss	= nr_versao_tiss_p
	and	a.ie_tipo_despesa	= ie_tipo_despesa_p
	and	dt_referencia_w between t.dt_inicio_vigencia_ref and t.dt_fim_vigencia_ref
	order by t.dt_inicio_vigencia_ref;

-- Material com Código FEDERAÇÃO
C03 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_material_tiss	t,
		pls_mat_unimed_fed_sc	f,
		pls_material		a
	where	a.nr_sequencia		= t.nr_seq_material
	and	f.nr_sequencia		= a.nr_seq_mat_uni_fed_sc
	and	f.cd_material		= cd_material_fed_w
	and	t.ds_versao_tiss	= nr_versao_tiss_p
	and	a.ie_tipo_despesa	= ie_tipo_despesa_p
	and	dt_referencia_w between t.dt_inicio_vigencia_ref and t.dt_fim_vigencia_ref
	order by t.dt_inicio_vigencia_ref;

-- Material com Código A900 (integridade de código)
C04 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_material_tiss	t,
		pls_material		a
	where	a.nr_sequencia		= t.nr_seq_material
	and	a.cd_material_a900	= cd_mat_a900_ops_w
	and	t.ds_versao_tiss	= nr_versao_tiss_p
	and	coalesce(a.ie_sistema_ant,'N') = 'N'
	and	a.ie_tipo_despesa	= ie_tipo_despesa_p
	and	dt_referencia_w between t.dt_inicio_vigencia_ref and t.dt_fim_vigencia_ref
	order by t.dt_inicio_vigencia_ref;

-- Material com Código MAT
C05 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_material_tiss	t,
		pls_material		a
	where	a.nr_sequencia		= t.nr_seq_material
	and	a.cd_material		= cd_material_w
	and	t.ds_versao_tiss	= nr_versao_tiss_p
	and	a.ie_tipo_despesa	= ie_tipo_despesa_p
	and	dt_referencia_w between t.dt_inicio_vigencia_ref and t.dt_fim_vigencia_ref
	order by t.dt_inicio_vigencia_ref;

-- Material com Sequencia MAT
C06 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_material_tiss	t,
		pls_material		a
	where	a.nr_sequencia		= t.nr_seq_material
	and	a.nr_sequencia		= nr_seq_material_w
	and	t.ds_versao_tiss	= nr_versao_tiss_p
	and	a.ie_tipo_despesa	= ie_tipo_despesa_p
	and	dt_referencia_w between t.dt_inicio_vigencia_ref and t.dt_fim_vigencia_ref
	order by t.dt_inicio_vigencia_ref;


BEGIN
dt_referencia_w		:= trunc(coalesce(dt_referencia_p,clock_timestamp()));
ie_valida_vig_mat_w	:= coalesce(ie_valida_vig_mat_p,'S');

-- Material com Código OPS
if (ie_opcao_p = 'O') and (coalesce(nr_seq_material_p::text, '') = '') then
	
	begin
		cd_material_ops_w	:= cd_mat_referencia_w;
	exception
	when others then
		cd_material_ops_w := null;
	end;
	
	if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material
		where	cd_material_ops_number		= cd_material_ops_w
		and	ds_versao_tiss		= nr_versao_tiss_p
		and (ie_valida_vig_mat_w	= 'N'
		or (ie_situacao		= 'A'
		and	ie_tipo_despesa		= ie_tipo_despesa_p
		and	dt_referencia_w between dt_inclusao_ref and DT_FIM_VIGENCIA_REF));

		if (coalesce(nr_seq_material_p::text, '') = '') then
			open C01;
			loop
			fetch C01 into
				nr_seq_material_p;
			EXIT WHEN NOT FOUND; /* apply on C01 */
			end loop;
			close C01;
		end if;
	end if;

	if (coalesce(nr_seq_material_p::text, '') = '') then
		if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material	a
			where	a.cd_material_ops_number	= cd_material_ops_w
			and	coalesce(a.ds_versao_tiss::text, '') = ''
			and	a.ie_tipo_despesa		= ie_tipo_despesa_p
			and (ie_valida_vig_mat_w	= 'N'
			or (a.ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(a.dt_inclusao,dt_referencia_w) and coalesce(a.dt_exclusao,dt_referencia_w)))
			and	not exists (SELECT	1
						from	pls_material_tiss	t
						where	a.nr_sequencia	= t.nr_seq_material);

		else
			select	max(nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material
			where	cd_material_ops_number	= cd_material_ops_w
			and	ie_tipo_despesa		= ie_tipo_despesa_p
			and (ie_valida_vig_mat_w	= 'N'
			or (ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));
		end if;
	end if;
end if;

-- Material com Código A900 (integridade de sequencia)
if (ie_opcao_p = 'A') and (coalesce(nr_seq_material_p::text, '') = '') then
	
	begin
		cd_material_a900_w	:= (cd_mat_referencia_w )::numeric;
	exception
	when others then
		cd_material_a900_w := null;
	end;
	
	if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material 		a,
			pls_material_unimed 	u
		where	u.nr_sequencia		= a.nr_seq_material_unimed
		and	u.cd_material		= cd_material_a900_w
		and	a.ie_tipo_despesa	= ie_tipo_despesa_p
		and	a.ds_versao_tiss	= nr_versao_tiss_p;

		if (coalesce(nr_seq_material_p::text, '') = '') then
			open C02;
			loop
			fetch C02 into
				nr_seq_material_p;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			end loop;
			close C02;
		end if;
	end if;

	if (coalesce(nr_seq_material_p::text, '') = '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material 		a,
			pls_material_unimed 	u
		where	u.nr_sequencia		= a.nr_seq_material_unimed
		and	u.cd_material		= cd_material_a900_w
		and	a.ie_tipo_despesa	= ie_tipo_despesa_p
		and	coalesce(a.ds_versao_tiss::text, '') = '';
	end if;
end if;

-- Material com Código FEDERAÇÃO
if (ie_opcao_p = 'F') and (coalesce(nr_seq_material_p::text, '') = '') then
	
	begin
		cd_material_fed_w	:= (cd_mat_referencia_w )::numeric;
	exception
	when others then
		cd_material_fed_w	:= null;
	end;
	
	if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material 		a,
			pls_mat_unimed_fed_sc	f
		where	f.nr_sequencia		= a.nr_seq_mat_uni_fed_sc
		and	f.cd_material		= cd_material_fed_w
		and	a.ie_tipo_despesa	= ie_tipo_despesa_p
		and	a.ds_versao_tiss	= nr_versao_tiss_p;

		if (coalesce(nr_seq_material_p::text, '') = '') then
			open C03;
			loop
			fetch C03 into
				nr_seq_material_p;
			EXIT WHEN NOT FOUND; /* apply on C03 */
			end loop;
			close C03;
		end if;
	end if;

	if (coalesce(nr_seq_material_p::text, '') = '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material 		a,
			pls_mat_unimed_fed_sc	f
		where	f.nr_sequencia		= a.nr_seq_mat_uni_fed_sc
		and	f.cd_material		= cd_material_fed_w
		and	a.ie_tipo_despesa	= ie_tipo_despesa_p
		and	coalesce(a.ds_versao_tiss::text, '') = '';
	end if;
end if;

-- Material com Código A900 (integridade de código)
if (ie_opcao_p = 'AC') and (coalesce(nr_seq_material_p::text, '') = '') then
	
	
	cd_mat_a900_ops_w	:= cd_mat_referencia_w;

	if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material
		where	cd_material_a900	= cd_mat_a900_ops_w
		and	ds_versao_tiss		= nr_versao_tiss_p
		and	coalesce(ie_sistema_ant,'N') = 'N'
		and	ie_tipo_despesa		= ie_tipo_despesa_p
		and (ie_valida_vig_mat_w	= 'N'
		or (ie_situacao		= 'A'
		and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));

		if (coalesce(nr_seq_material_p::text, '') = '') then
			open C04;
			loop
			fetch C04 into
				nr_seq_material_p;
			EXIT WHEN NOT FOUND; /* apply on C04 */
			end loop;
			close C04;
		end if;
	end if;

	if (coalesce(nr_seq_material_p::text, '') = '') then
		if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material
			where	cd_material_a900 = cd_mat_a900_ops_w
			and	coalesce(ds_versao_tiss::text, '') = ''
			and	coalesce(ie_sistema_ant,'N') = 'N'
			and	ie_tipo_despesa		= ie_tipo_despesa_p
			and (ie_valida_vig_mat_w	= 'N'
			or (ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));

		else
			select	max(nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material
			where	cd_material_a900 = cd_mat_a900_ops_w
			and	ie_tipo_despesa		= ie_tipo_despesa_p
			and	coalesce(ie_sistema_ant,'N') = 'N'
			and (ie_valida_vig_mat_w	= 'N'
			or (ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));
		end if;
	end if;
end if;

-- Material com Código MAT
if (ie_opcao_p = 'M') and (coalesce(nr_seq_material_p::text, '') = '') then
	
	
	begin
		cd_material_w	:= (cd_mat_referencia_w)::numeric;
	exception
	when others then
		cd_material_w := null;
	end;
	
	
	if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material
		where	cd_material		= cd_material_w
		and	ds_versao_tiss		= nr_versao_tiss_p
		and	ie_tipo_despesa		= ie_tipo_despesa_p
		and (ie_valida_vig_mat_w	= 'N'
		or (ie_situacao		= 'A'
		and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));

		if (coalesce(nr_seq_material_p::text, '') = '') then
			open C05;
			loop
			fetch C05 into
				nr_seq_material_p;
			EXIT WHEN NOT FOUND; /* apply on C05 */
			end loop;
			close C05;
		end if;
	end if;

	if (coalesce(nr_seq_material_p::text, '') = '') then
		if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material	a
			where	a.cd_material	= cd_material_w
			and	a.ie_tipo_despesa	= ie_tipo_despesa_p
			and	coalesce(a.ds_versao_tiss::text, '') = ''
			and (ie_valida_vig_mat_w	= 'N'
			or (a.ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(a.dt_inclusao,dt_referencia_w) and coalesce(a.dt_exclusao,dt_referencia_w)))
			and	not exists (SELECT	1
						from	pls_material_tiss	t
						where	a.nr_sequencia	= t.nr_seq_material);

		else
			select	max(nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material
			where	cd_material	= cd_material_w
			and	ie_tipo_despesa		= ie_tipo_despesa_p
			and (ie_valida_vig_mat_w	= 'N'
			or (ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));
		end if;
	end if;
end if;

-- Material com Sequencia MAT
if (ie_opcao_p = 'S') and (coalesce(nr_seq_material_p::text, '') = '') then
	
	begin
		nr_seq_material_w	:= (cd_mat_referencia_w )::numeric;
	exception
	when others then
		nr_seq_material_w := null;
	end;
	
	if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_material_p
		from	pls_material		a
		where	nr_sequencia		= nr_seq_material_w
		and	a.ie_tipo_despesa	= ie_tipo_despesa_p
		and	ds_versao_tiss	= nr_versao_tiss_p
		and (ie_valida_vig_mat_w	= 'N'
		or (ie_situacao		= 'A'
		and	dt_referencia_w between dt_inclusao_ref and dt_fim_vigencia_ref));

		if (coalesce(nr_seq_material_p::text, '') = '') then
			open C06;
			loop
			fetch C06 into
				nr_seq_material_p;
			EXIT WHEN NOT FOUND; /* apply on C06 */
			end loop;
			close C06;
		end if;
	end if;

	if (coalesce(nr_seq_material_p::text, '') = '') then
		if (nr_versao_tiss_p IS NOT NULL AND nr_versao_tiss_p::text <> '') then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material	a
			where	a.nr_sequencia	= nr_seq_material_w
			and	coalesce(a.ds_versao_tiss::text, '') = ''
			and	a.ie_tipo_despesa	= ie_tipo_despesa_p
			and (ie_valida_vig_mat_w	= 'N'
			or (a.ie_situacao		= 'A'
			and	dt_referencia_w between a.dt_inclusao_ref and a.dt_fim_vigencia_ref))
			and	not exists (SELECT	1
						from	pls_material_tiss	t
						where	a.nr_sequencia	= t.nr_seq_material);

		else
			select	max(nr_sequencia)
			into STRICT	nr_seq_material_p
			from	pls_material
			where	nr_sequencia		= nr_seq_material_w
			and	ie_tipo_despesa		= ie_tipo_despesa_p
			and (ie_valida_vig_mat_w	= 'N'
			or (ie_situacao		= 'A'
			and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)));
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_mat_vigente_desp ( nr_seq_material_p INOUT pls_material.nr_sequencia%type, dt_referencia_p timestamp, cd_mat_referencia_w text, ie_opcao_p text, ie_valida_vig_mat_p text, nr_versao_tiss_p pls_material_tiss.ds_versao_tiss%type, ie_tipo_despesa_p pls_material.ie_tipo_despesa%type) FROM PUBLIC;

