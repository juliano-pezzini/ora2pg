-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_erro_prescr_proced ( nr_prescricao_p bigint, nr_seq_proced_p bigint, nr_cor_padrao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_cor_erro_w	varchar(15)	:= null;
ds_cor_regra_w	varchar(15)	:= null;
ds_cor_fundo_w	varchar(15)	:= null;
ds_cor_fonte_w	varchar(15)	:= null;
ds_cor_selecao_w	varchar(15)	:= null;

c01 CURSOR FOR
SELECT	ds_cor
from	prescr_medica_erro
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_proced	= nr_seq_proced_p
order by
	coalesce(ie_prioridade,999);

/*
ie_opcao_p:
C - Cor de fundo
F - Cor da fonte
S - Cor de seleção
*/
BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_proced_p IS NOT NULL AND nr_seq_proced_p::text <> '') and (nr_cor_padrao_p IS NOT NULL AND nr_cor_padrao_p::text <> '') then

	open c01;
	loop
	fetch c01 into ds_cor_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_cor_regra_w	:= ds_cor_regra_w;
		end;
	end loop;
	close c01;

	if (ds_cor_regra_w IS NOT NULL AND ds_cor_regra_w::text <> '') then
		ds_cor_erro_w	:= ds_cor_regra_w;
	else
		SELECT * FROM tasy_obter_cor(nr_cor_padrao_p, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
		if (coalesce(ie_opcao_p,'C') = 'C') then
				ds_cor_erro_w	:= ds_cor_fundo_w;
		elsif (ie_opcao_p = 'F') then
				ds_cor_erro_w	:= ds_cor_fonte_w;
		elsif (ie_opcao_p = 'S') then
				ds_cor_erro_w	:= ds_cor_selecao_w;
		end if;
	end if;

end if;

return ds_cor_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_erro_prescr_proced ( nr_prescricao_p bigint, nr_seq_proced_p bigint, nr_cor_padrao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, ie_opcao_p text) FROM PUBLIC;

