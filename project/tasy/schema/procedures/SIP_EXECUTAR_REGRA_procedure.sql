-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_executar_regra ( nr_seq_lote_sip_p bigint, nr_seq_regra_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_cid_principal_p text, nr_seq_saida_int_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_regra_p INOUT text) AS $body$
DECLARE


cd_area_proc_w		bigint		:= 0;
cd_espec_proc_w		bigint		:= 0;
cd_grupo_proc_w		bigint		:= 0;
ie_estrutura_w		varchar(1)		:= 'S';
cd_estrutura_w		varchar(10)		:= '';
ds_regra_w		varchar(255);
ie_expostos_w		varchar(1);
ie_quantidade_w		varchar(1);
ie_regra_w		varchar(1)		:= 'N';
cd_categoria_cid_w	varchar(10);

C01 CURSOR FOR
	SELECT	coalesce(ie_estrutura, 'S')
	from	sip_regra_criterio
	where	nr_seq_regra_sip	= nr_seq_regra_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(cd_procedimento, cd_procedimento_p)		= cd_procedimento_p
	and	coalesce(ie_origem_proced, ie_origem_proced_p)	= ie_origem_proced_p
	and	coalesce(cd_grupo_proc, cd_grupo_proc_w) 		= cd_grupo_proc_w
	and	coalesce(cd_especialidade, cd_espec_proc_w) 		= cd_espec_proc_w
	and	coalesce(cd_area_procedimento, cd_area_proc_w) 	= cd_area_proc_w
	and	((coalesce(cd_cid_principal, cd_cid_principal_p)	= cd_cid_principal_p) or (coalesce(cd_cid_principal,cd_categoria_cid_w)	= cd_categoria_cid_w))
	and	coalesce(nr_seq_saida_int, nr_seq_saida_int_p)	= nr_seq_saida_int_p
	order by
		coalesce(cd_procedimento,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_especialidade,0),
		coalesce(cd_area_procedimento,0);


BEGIN

/* Obter Estrutura do procedimento */

begin
select	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc
into STRICT	cd_area_proc_w,
	cd_espec_proc_w,
	cd_grupo_proc_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;
exception
     	when others then
	begin
	cd_area_proc_w		:= 0;
	cd_espec_proc_w		:= 0;
	cd_grupo_proc_w		:= 0;
	end;
end;

select	cd_estrutura,
	ds_regra,
	ie_expostos,
	ie_quantidade
into STRICT	cd_estrutura_w,
	ds_regra_w,
	ie_expostos_w,
	ie_quantidade_w
from	sip_regra
where	nr_sequencia	= nr_seq_regra_p;

/* Buscar a categoria do CID */

select	coalesce(max(cd_categoria_cid),'')
into STRICT	cd_categoria_cid_w
from	cid_doenca
where	cd_doenca_cid	= cd_cid_principal_p;

open C01;
loop
fetch C01 into
	ie_estrutura_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_estrutura_w	= 'S') then
		ie_regra_w	:= 'S';
	else
		ie_regra_w	:= 'N';
	end if;
	end;
end loop;
close C01;

ie_regra_p	:= ie_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_executar_regra ( nr_seq_lote_sip_p bigint, nr_seq_regra_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_cid_principal_p text, nr_seq_saida_int_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_regra_p INOUT text) FROM PUBLIC;

