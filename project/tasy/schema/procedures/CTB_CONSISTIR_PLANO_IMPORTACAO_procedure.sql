-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_consistir_plano_importacao ( cd_empresa_p bigint, nm_usuario_p text) AS $body$
DECLARE



qt_registros_w			bigint	:= 0;
ds_consistencia_w			varchar(4000);
ie_pos_ponto_classif_w		varchar(1);
ie_nivel_conta_w			bigint;
ie_separador_conta_w		empresa.ie_sep_classif_conta_ctb%type;
ie_natureza_sped_w          varchar(1);

c01 CURSOR FOR
SELECT	a.*
from	w_imp_conta_contabil a
order by a.nr_sequencia;

vet01	c01%RowType;


BEGIN

ie_separador_conta_w	 := philips_contabil_pck.get_separador_conta;


open C01;
loop
fetch C01 into	
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_consistencia_w	:= '';
	/*if	(nvl(vet01.cd_conta_contabil, 'X') <> 'X') then
		
		select	count(*)
		into	qt_registros_w
		from	conta_contabil
		where	cd_conta_contabil	= vet01.cd_conta_contabil;
		
		if	(qt_registros_w > 0) then
			
			ds_consistencia_w	:= ds_consistencia_w||chr(13)||'Conta ja existe no Tasy com o codigo: '||vet01.cd_conta_contabil;
			
		end if;
		
	end if;*/
	/*Consistir se a conta possui classificacaoo, como tambem a existencia dos pontos na mesma*/

	if (coalesce(vet01.cd_classificacao, 'X') <> 'X') then
		
		ie_pos_ponto_classif_w	:= position(ie_separador_conta_w in vet01.cd_classificacao);
		ie_nivel_conta_w		:= coalesce(length(vet01.cd_classificacao),0);
		
		if (ie_pos_ponto_classif_w = 0) and (ie_nivel_conta_w > 1)then
			
			ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(293805,'IE_SEPARADOR_CONTA_W=' || ie_separador_conta_w) || chr(13),1,4000);

		end if;
		
		
	else
		ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(293833) || chr(13),1,4000);
	end if;
	
	
	/*Verificar se existe a classificacao superior no cadastro
	if	(nvl(vet01.cd_classif_sup, 'X') <> 'X') then
		
		select	count(*)
		into	qt_registros_w
		from	conta_contabil
		where	cd_classificacao_atual = vet01.cd_classif_sup;
		
		if	(qt_registros_w = 0) then
			
			ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(293837) || chr(13),1,4000);
			
		end if;
		
	end if;*/
	/*Consistencia de exigencia de Centro de custo pela conta*/

	if (vet01.ie_centro_custo not in ('S', 'N')) then
		
		ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(293838) || chr(13),1,4000);
		
	end if;

	/*COnsistencia do Tipo da Conta Analitica ou Sintetica*/

	if (vet01.ie_tipo not in ('T', 'A')) then
		
		ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(293839) || chr(13),1,4000);
		
	end if;

	/*Consistencia do codigo do Grupo de contas para vinculo*/

	if (coalesce(vet01.cd_grupo, 0) <> 0) then
		
		select	count(*)
		into STRICT	qt_registros_w
		from	ctb_grupo_conta
		where	cd_grupo		= vet01.cd_grupo;
		
		if (qt_registros_w = 0) then
			
			ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(293840) || chr(13),1,4000);
			
		end if;
		
		
	end if;

	if (coalesce(vet01.ie_natureza_sped, 'X') <> 'X') then
		ie_natureza_sped_w := obter_se_valor_dominio_ativo(4696,vet01.ie_natureza_sped);
		if (ie_natureza_sped_w = 'N') then
			ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(1199943) || chr(13),1,4000);
		end if;
	end if;

	if (coalesce(vet01.ie_ecd_reg_bp, 'X') <> 'X') and (vet01.ie_ecd_reg_bp not in ('S', 'N')) then
		ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(1199944) || chr(13),1,4000);
	end if;

	if (coalesce(vet01.ie_ecd_reg_dre, 'X') <> 'X') and (vet01.ie_ecd_reg_dre not in ('S', 'N')) then
		ds_consistencia_w	:= substr(ds_consistencia_w || wheb_mensagem_pck.get_texto(1199945) || chr(13),1,4000);
	end if;
	
	update	w_imp_conta_contabil
	set	ds_consistencia	= ds_consistencia_w
	where	nr_sequencia	= vet01.nr_sequencia;
	
	end;
end loop;
close C01;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_consistir_plano_importacao ( cd_empresa_p bigint, nm_usuario_p text) FROM PUBLIC;

