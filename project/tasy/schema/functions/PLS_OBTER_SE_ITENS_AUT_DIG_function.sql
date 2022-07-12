-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_itens_aut_dig ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(4000) := '';
cd_guia_w			varchar(20);
nr_seq_segurado_w		bigint;
nr_seq_guia_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_material_w		bigint;
qt_proc_w			smallint;
ie_contador_w			smallint := 0;
qt_mat_w			smallint;
nr_seq_guia_pror_w		bigint;
cd_material_w			varchar(20);
qt_autorizado_w			bigint;
qt_diferenca_w			bigint;
nr_seq_conta_proc_w		bigint;
ie_exige_aut_w			varchar(1)	:= 'N';

C01 CURSOR FOR
	SELECT	coalesce(sum(qt_autorizada),0),
		cd_procedimento,
		ie_origem_proced
	from	pls_guia_plano_proc
	where	((nr_seq_guia = nr_seq_guia_pror_w) or (nr_seq_guia = nr_seq_guia_w )) -- Diego OS 314744 - Hist. 14/06/2011 08:31:58 - Obter os procedimentos de uma guia de prorrogação de internação
	and	ie_status in ('L','S','P') --Somente itens liberados seja pelo auditor, usuário ou sistema.
	group by cd_procedimento,
		 ie_origem_proced;

C02 CURSOR FOR
	SELECT	coalesce(sum(qt_autorizada),0),
		nr_seq_material
	from	pls_guia_plano_mat
	where	((nr_seq_guia = nr_seq_guia_pror_w) or (nr_seq_guia = nr_seq_guia_w))
	and	ie_status in ('L','S','P') --Somente itens liberados seja pelo auditor, usuário ou sistema.
	group by nr_seq_material;


BEGIN

if (pls_obter_conta_princ_atend(nr_seq_conta_p, cd_estabelecimento_p, nm_usuario_p) <> nr_seq_conta_p) then
	goto Final;
end if;

select	coalesce(cd_guia_referencia, cd_guia),
	nr_seq_segurado
into STRICT	cd_guia_w,
	nr_seq_segurado_w
from	pls_conta
where 	nr_sequencia = nr_seq_conta_p;

select	max(nr_sequencia)
into STRICT	nr_seq_guia_w
from	pls_guia_plano
where	cd_guia 	= cd_guia_w
and	nr_seq_segurado = nr_seq_segurado_w;

select	max(nr_sequencia)
into STRICT	nr_seq_guia_pror_w
from	pls_guia_plano
where	cd_guia_principal 	= cd_guia_w
and	nr_seq_segurado 	= nr_seq_segurado_w
and	ie_tipo_guia		= '8';

open C01;
loop
fetch C01 into
	qt_autorizado_w,
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_exige_aut_w	:= pls_obter_exigencia_guia(nr_seq_conta_p,cd_procedimento_w,ie_origem_proced_w,null);

	/* Somente realizar a consistência para os procedimentos que exigem autorização */

	if (ie_exige_aut_w = 'S') then
		begin
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_conta_proc_w
		from	pls_conta_proc a,
			pls_conta b
		where	coalesce(b.cd_guia_referencia, b.cd_guia)	= cd_guia_w
		and	a.cd_procedimento		 	= cd_procedimento_w
		and	a.ie_origem_proced		 	= ie_origem_proced_w
		and	a.nr_seq_conta				= b.nr_sequencia
		and	b.nr_seq_segurado			= nr_seq_segurado_w;
		exception
		when others then
			nr_seq_conta_proc_w := 0;
		end;

		/*Diego OS 314744 - Hist. 02/08/2011 09:48:44 - Só será lançada a ocorrência se o item EXISTIR na conta mas não for utilizado a pleno*/

		if (coalesce(nr_seq_conta_proc_w,0) = 0) then
			if (ie_contador_w = 0) then
				ds_retorno_w 	:= 'Os seguintes procedimentos autorizados não foram utilizados:'||chr(13)||chr(10);
				ie_contador_w	:= 1;
			end if;
			ds_retorno_w	:= ds_retorno_w||chr(9)||cd_procedimento_w||' - '||Obter_Descricao_Procedimento(cd_procedimento_w,ie_origem_proced_w)||' - Qt. autorizada: '||qt_autorizado_w||chr(13)||chr(10);
		end if;
	end if;

	end;
end loop;
close C01;

ie_contador_w := 0;

open C02;
loop
fetch C02 into
	qt_autorizado_w,
	nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ie_exige_aut_w	:= pls_obter_exigencia_guia(nr_seq_conta_p,null,null,nr_seq_material_w);

	/* Somente realizar a consistência para os materiais que exigem autorização */

	if (ie_exige_aut_w = 'S') then
		select	count(a.nr_sequencia)
		into STRICT	qt_mat_w
		from	pls_conta_mat a,
			pls_conta b
		where	coalesce(b.cd_guia_referencia, b.cd_guia)	= cd_guia_w
		and	nr_seq_material				= nr_seq_material_w
		and	a.nr_seq_conta				= b.nr_sequencia
		and	b.nr_seq_segurado			= nr_seq_segurado_w;

		/*Diego OS 314744 - Hist. 02/08/2011 09:48:44 - Só será lançada a ocorrência se o item EXISTIR na conta mas não for utilizado a pleno*/

		if (qt_mat_w = 0) then
			/*Verificar se o material da autorização esta na conta.*/

			select	max(cd_material_ops)
			into STRICT	cd_material_w
			from	pls_material
			where	nr_sequencia = nr_seq_material_w;

			if (ie_contador_w = 0) then
				ds_retorno_w := ds_retorno_w || 'Os seguintes materiais autorizados não foram utilizados:' || chr(13) || chr(10);
				ie_contador_w := 1;
			end if;
			ds_retorno_w 	:= ds_retorno_w||chr(9)||coalesce(cd_material_w,nr_seq_material_w)||' - '||pls_obter_desc_material(nr_seq_material_w)||' - Qt. autorizada: '||qt_autorizado_w||chr(13)||chr(10);
		end if;
	end if;

	end;
end loop;
close C02;

<<Final>>

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_itens_aut_dig ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

