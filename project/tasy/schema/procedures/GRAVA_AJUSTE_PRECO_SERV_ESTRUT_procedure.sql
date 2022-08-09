-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_ajuste_preco_serv_estrut (CD_AREA_PROCEDIMENTO_p bigint, CD_ESPECIALIDADE_p bigint, CD_GRUPO_PROC_p bigint, CD_ESTABELECIMENTO_P bigint, CD_TAB_ORIGEM_P bigint, CD_TAB_DESTINO_P bigint, DT_VIGENCIA_ORIGEM_P timestamp, DT_VIGENCIA_DESTINO_P timestamp, IE_INDICE_P bigint, IE_ULTIMA_VIGENCIA_P text, NM_USUARIO_P text) AS $body$
DECLARE


cd_procedimento_w	bigint;

C01 CURSOR FOR
	SELECT	cd_procedimento
	from	estrutura_procedimento_v
	where (cd_grupo_proc		= coalesce(cd_grupo_proc_p, cd_grupo_proc))
	and (cd_especialidade	= coalesce(cd_especialidade_p, cd_especialidade))
	and (CD_AREA_PROCEDIMENTO	= coalesce(CD_AREA_PROCEDIMENTO_p, CD_AREA_PROCEDIMENTO));


BEGIN

open	c01;
loop
fetch	c01 into cd_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	CALL GRAVA_AJUSTE_PRECO_SERVICO(CD_ESTABELECIMENTO_P,
		CD_TAB_ORIGEM_P,
		CD_TAB_DESTINO_P,
		CD_PROCEDIMENTO_w,
		DT_VIGENCIA_ORIGEM_P,
		DT_VIGENCIA_DESTINO_P,
		IE_INDICE_P,
		NM_USUARIO_P,
		coalesce(IE_ULTIMA_VIGENCIA_P,'N'),'N',0);


	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_ajuste_preco_serv_estrut (CD_AREA_PROCEDIMENTO_p bigint, CD_ESPECIALIDADE_p bigint, CD_GRUPO_PROC_p bigint, CD_ESTABELECIMENTO_P bigint, CD_TAB_ORIGEM_P bigint, CD_TAB_DESTINO_P bigint, DT_VIGENCIA_ORIGEM_P timestamp, DT_VIGENCIA_DESTINO_P timestamp, IE_INDICE_P bigint, IE_ULTIMA_VIGENCIA_P text, NM_USUARIO_P text) FROM PUBLIC;
