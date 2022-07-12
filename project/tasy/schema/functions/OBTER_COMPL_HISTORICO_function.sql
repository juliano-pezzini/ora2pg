-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (ds_campo_w		varchar(255));


CREATE OR REPLACE FUNCTION obter_compl_historico ( cd_tipo_lote_contabil_p bigint, cd_historico_p bigint, ds_conteudo_p text) RETURNS varchar AS $body$
DECLARE

	
ds_conteudo_w			varchar(4000);
ds_mascara_w			varchar(30);
qt_hist_w				bigint;
ds_retorno_w			varchar(4000);
nm_atributo_w			varchar(50);
vl_atributo_w			varchar(255);
ds_caracter_pre_w			varchar(255);
ds_caracter_pos_w			varchar(255);
ie_funcao_w			varchar(15);
i				integer;
k				integer;
q				integer;
ie_hist_maiusculo_w		varchar(1) := 'N';
ie_manter_nulo_w		varchar(1) := 'N';
type Vetor is table of campos index by integer;
ds_atributo_w		Vetor;
ds_valor_w		Vetor;

C01 CURSOR FOR
	SELECT	nm_atributo
	from	atributo_compl_hist
	where	cd_tipo_lote_contab = cd_tipo_lote_contabil_p
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	a.nm_atributo,
		b.ds_caracter_pre,
		b.ds_caracter_pos,
		b.ie_funcao,
		b.ds_mascara,
		coalesce(b.ie_manter_nulo,'N') ie_manter_nulo
	from 	historico_padrao_atributo	b,
		atributo_compl_hist		a
	where 	b.nr_seq_atributo	= a.nr_sequencia
	and	b.cd_tipo_lote_contabil	= cd_tipo_lote_contabil_p
	and 	b.cd_historico		= cd_historico_p
	and	b.cd_tipo_lote_contabil	= a.cd_tipo_lote_contab 
	order by
		b.nr_seq_apres;


BEGIN
ds_retorno_w				:= '';
/* identificar os atributos do tipo de lote contabil e inseri-los no vetor ds_atributo_w */

i := 0;
OPEN C01;
LOOP
FETCH C01 into
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	i := I + 1;
	ds_atributo_w[i].ds_campo_w	:= nm_atributo_w;
END LOOP;
CLOSE C01;

/* Receber o conteudo dos atributos passados como parametro e inseri-los no vetor ds_valor_w */

i := 0;
ds_conteudo_w				:= ds_conteudo_p;
while(length(ds_conteudo_w) > 0)  loop
	k 				:= position('#@' in ds_conteudo_w);
	if (k = 0) then
		vl_atributo_w		:= substr(ds_conteudo_w,1,255);
		ds_conteudo_w		:= '';
	else
		vl_atributo_w		:= substr(substr(ds_conteudo_w,1, k - 1),1,255);
		ds_conteudo_w		:= substr(ds_conteudo_w, k + 2, 4000);
	end if;
	i := I + 1;
	ds_valor_w[i].ds_campo_w	:= vl_atributo_w;
end loop;

/* Identificar a ordem dos campos para o historico e tipo de lote e montar o complemento a ser retornado */

OPEN C02;
LOOP
FETCH C02 into
	nm_atributo_w,
	ds_caracter_pre_w,
	ds_caracter_pos_w,
	ie_funcao_w,
	ds_mascara_w,
	ie_manter_nulo_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	q	:= 0;
	FOR k IN 1..i LOOP
		if (nm_atributo_w = ds_atributo_w[k].ds_campo_w) then
			q	:= k;
		end if;
	END LOOP;
	if (q <> 0) then
		vl_atributo_w		:= ds_valor_w[q].ds_campo_w;

		if ((vl_atributo_w IS NOT NULL AND vl_atributo_w::text <> '') or ie_manter_nulo_w = 'S') then
	
			if (ie_funcao_w = 'Upper') then
				vl_atributo_w	:= upper(vl_atributo_w);
			elsif (ie_funcao_w = 'Lower') then
				vl_atributo_w	:= Lower(vl_atributo_w);
			elsif (ie_funcao_w = 'Initcap') then
				vl_atributo_w	:= Initcap(vl_atributo_w);
			end if;
			if (ds_mascara_w IS NOT NULL AND ds_mascara_w::text <> '') then
				begin
				vl_atributo_w		:= to_char(to_date(vl_atributo_w,'dd/mm/yy hh24:mi:ss'),ds_mascara_w);
				exception when others then
					vl_atributo_w	:= ds_valor_w[q].ds_campo_w;
				end;
			end if;
			ds_retorno_w	:= ds_retorno_w || ds_caracter_pre_w || vl_atributo_w || ds_caracter_pos_w; 	
		end if;
	end if;
END LOOP;
CLOSE C02;

/*begin
	obter_param_usuario(135,36,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento,ie_hist_maiusculo_w);
exception
	when others then
	ie_hist_maiusculo_w := 'N';
end;*/
if (ie_hist_maiusculo_w = 'S') then
	ds_retorno_w := upper(ds_retorno_w);
end if;

return substr(ds_retorno_w,1,255);

End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_compl_historico ( cd_tipo_lote_contabil_p bigint, cd_historico_p bigint, ds_conteudo_p text) FROM PUBLIC;

