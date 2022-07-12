-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_material_nut_concat ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/*
MT	=	CÓDIGO DO MATERIAL
VR	= 	VAL.SOB.REFRIG.
RF	=	VALIDADE EM TEMPERATURA
VA	=	VALIDADE
*/
ds_retorno_w				varchar(4000)	:= '';
ds_retorno2_w				varchar(80) 	:= '';
cd_material_w				integer;
ds_val_sob_ref_w			varchar(200);
ds_referencia_w				varchar(255);
ds_estagio_w				varchar(80);
ds_forma_w					varchar(80);
ds_estabilidade_w			varchar(20);
ie_estab_fornec_w			varchar(1);
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

c01 CURSOR FOR
	SELECT 	a.cd_material,
			substr(b.qt_estabilidade || ' ' || obter_valor_dominio(1246,b.ie_tempo_estab) || '; ' || obter_desc_forma_armazenamento(b.nr_seq_forma),1,200),
			b.ds_referencia,
			substr(obter_estagio_armazenamento(b.nr_seq_estagio),1,200),
			substr(obter_desc_forma_armazenamento(b.nr_seq_forma),1,200),
			substr(b.qt_estabilidade || ' ' || obter_valor_dominio(1246,b.ie_tempo_estab),1,200),
			b.ie_estab_fornec
	from	nut_atend_serv_dia_dieta a,
			material_armazenamento b,
			nut_atend_serv_dieta c
	where	c.nr_seq_dieta = a.nr_sequencia
	and		b.cd_material	= a.cd_material
	and		c.nr_seq_servico = nr_sequencia_p
	and	 	coalesce(b.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and   	((a.ie_via_aplicacao	= b.ie_via_aplicacao) or
			 ((coalesce(b.ie_via_aplicacao::text, '') = '') and
			   not exists (SELECT	1
						   from 	material_armazenamento d
						   where 	d.cd_material 		= a.cd_material
						   and   	d.ie_via_aplicacao	= a.ie_via_aplicacao
						   and 	coalesce(d.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w)))
	and		coalesce(a.dt_suspensao::text, '') = '';


BEGIN

cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento, 0);

open c01;
loop
fetch c01 into
		cd_material_w,
		ds_val_sob_ref_w,
		ds_referencia_w,
		ds_estagio_w,
		ds_forma_w,
		ds_estabilidade_w,
		ie_estab_fornec_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ie_opcao_p = 'MT') then
		ds_retorno_w := ds_retorno_w|| cd_material_w||'  ';
	elsif (ie_opcao_p = 'VR') then
		ds_retorno_w := ds_retorno_w|| ds_val_sob_ref_w||'  ';
	ELSIF (IE_OPCAO_P = 'RF') then
		ds_retorno_w := ds_retorno_w|| ds_referencia_w||'  ';
	elsif (ie_opcao_p = 'VA') then
		if (ie_estab_fornec_w = 'N') then
			ds_retorno_w := wheb_mensagem_pck.get_texto(309571) || ': ' || ds_estagio_w || '; ' || ds_forma_w || '; ' || ds_estabilidade_w||' '||ds_referencia_w||'  '; -- Validade
		elsif (ie_estab_fornec_w = 'S') then
			ds_retorno_w := wheb_mensagem_pck.get_texto(309571) || ': ' || ds_estagio_w || '; ' || ds_forma_w || '; ' || wheb_mensagem_pck.get_texto(309572) || '  '||ds_referencia_w||'  '; -- Validade	-- Vide Fabricante
		end if;
	end if;

	end;
end loop;
close c01;

 if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w)-2);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_material_nut_concat ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
