-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_item_acao_auditor ( nr_seq_item_analise_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p bigint, nr_seq_analise_p bigint ) RETURNS varchar AS $body$
DECLARE


nr_seq_conta_proc_mat_w			bigint;
ds_retorno_w				varchar(1)	:= 'N';
ds_retorno_ww				varchar(1);
ds_tipo_despesa_w			varchar(3);
nr_seq_conta_proc_w			bigint;
nr_seq_conta_mat_w			bigint;
cd_ocorrencia_w				varchar(15);
nr_seq_conta_w				bigint;

/*Obter ocorrencias do item*/

C01 CURSOR FOR
	SELECT	cd_codigo
	from	pls_analise_conta_item
	where	((nr_seq_conta = nr_seq_conta_w and ((coalesce(nr_seq_conta_proc,0) = 0) and (coalesce(nr_seq_conta_mat,0) = 0)))
	or	 (nr_seq_conta = nr_seq_conta_w and ((nr_seq_conta_proc = nr_seq_conta_proc_w) or (nr_seq_conta_mat = nr_seq_conta_mat_w))))
	and	ie_tipo = 'O'
	and	ie_status in ('P', 'E')
	and	nr_seq_analise = nr_seq_analise_p;


BEGIN
/*
select	nr_seq_item,
	nr_seq_conta,
	ds_tipo_despesa
into	nr_seq_conta_proc_mat_w,
	nr_seq_conta_w,
	ds_tipo_despesa_w
from	w_pls_resumo_conta
where	nr_sequencia = nr_seq_item_analise_p;

if	(ds_tipo_despesa_w in ('P1', 'P2', 'P3', 'P4')) then --Procedimento
	nr_seq_conta_proc_w	:=	nr_seq_conta_proc_mat_w;
	nr_seq_conta_mat_w 	:= 0;

	open C01;
	loop
	fetch C01 into
		cd_ocorrencia_w;
	exit when C01%notfound;
		begin

		ds_retorno_w := pls_obter_dados_auditor(cd_ocorrencia_w, null, nm_usuario_p,
							'C', nr_seq_grupo_atual_p) ;

		if	(ds_retorno_w = 'S') then
			ds_retorno_ww := 'S';
			goto final;
		end if;

		end;
	end loop;
	close C01;

elsif	(ds_tipo_despesa_w in ('M1', 'M2', 'M3', 'M4')) then --Material
	nr_seq_conta_mat_w	:=	nr_seq_conta_proc_mat_w;
	nr_seq_conta_proc_w	:=	0;

	open C01;
	loop
	fetch C01 into
		cd_ocorrencia_w;
	exit when C01%notfound;
		begin

		ds_retorno_w := pls_obter_dados_auditor(cd_ocorrencia_w, null, nm_usuario_p,
							'C', nr_seq_grupo_atual_p) ;

		if	(ds_retorno_w = 'S') then
			ds_retorno_ww := 'S';
			goto final;
		end if;

		end;
	end loop;
	close C01;

end if;
*/
<<final>>
return ds_retorno_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_item_acao_auditor ( nr_seq_item_analise_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p bigint, nr_seq_analise_p bigint ) FROM PUBLIC;
