-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE san_gerar_codigo_isbt.san_gravar_cod_isbt_fenot ( nr_seq_doacao_p bigint) AS $body$
DECLARE


ds_fenotipagem_w	varchar(255);
nr_posicao_str_w       	bigint;
nr_seq_doacao_w     SAN_RESULT_FENOTIPAGEM.nr_seq_doacao%type;
nr_seq_producao_w     SAN_RESULT_FENOTIPAGEM.nr_seq_producao%type;
ds_fenotipo_w          	varchar(15);
ds_posicao1_w          	varchar(155);
ds_posicao1_r_w         varchar(155);
ds_posicao2_w          	varchar(155);
ds_posicao3_w          	varchar(155);
ds_posicao4_w 		varchar(155);
ds_posicao5_w 		varchar(155);
ds_posicao6_w 		varchar(155);
ds_posicao7_w 		varchar(155);
ds_posicao8_w 		varchar(155);
ds_posicao9_w 		varchar(155);
ds_posicao10_w		varchar(155);
ds_posicao11_w		varchar(155);
ds_posicao12_w		varchar(155);
ds_posicao13_w		varchar(155);
ds_posicao14_w		varchar(155);
ds_posicao15_w		varchar(155);
ds_posicao16_w		varchar(155);
ds_posicao17_18_w	varchar(155);
ie_entrou_w         	varchar(1);
ds_ant1_pos_1_w         varchar(155);
ds_ant1_pos_2_w         varchar(155);
ds_ant1_pos_3_w     	varchar(155);
ds_ant1_pos_4_w 	varchar(155);
ds_ant1_pos_5_w 	varchar(155);
ds_ant1_pos_6_w 	varchar(155);
ds_ant1_pos_7_w 	varchar(155);
ds_ant1_pos_8_w 	varchar(155);
ds_ant1_pos_9_w 	varchar(155);
ds_ant1_pos_10_w	varchar(155);
ds_ant1_pos_11_w	varchar(155);
ds_ant1_pos_12_w	varchar(155);
ds_ant1_pos_13_w	varchar(155);
ds_ant1_pos_14_w	varchar(155);
ds_ant1_pos_15_w	varchar(155);
ds_ant1_pos_16_w	varchar(155);
ds_ant2_pos_1_w         varchar(155);
ds_ant2_pos_2_w         varchar(155);
ds_ant2_pos_3_w     	varchar(155);
ds_ant2_pos_4_w 	varchar(155);
ds_ant2_pos_5_w 	varchar(155);
ds_ant2_pos_6_w 	varchar(155);
ds_ant2_pos_7_w 	varchar(155);
ds_ant2_pos_8_w 	varchar(155);
ds_ant2_pos_9_w 	varchar(155);
ds_ant2_pos_10_w	varchar(155);
ds_ant2_pos_11_w	varchar(155);
ds_ant2_pos_12_w	varchar(155);
ds_ant2_pos_13_w	varchar(155);
ds_ant2_pos_14_w	varchar(155);
ds_ant2_pos_15_w	varchar(155);
ds_antigeno1_w		varchar(155);
ds_antigeno2_w		varchar(155);
nr_posicao_ant_w	bigint;

c01 CURSOR FOR
SELECT
  Obter_Descricao_Dominio(3887,CD_PRIMEIRO_ANTIGENO),
  Obter_Descricao_Dominio(3887,CD_segundo_ANTIGENO),
  nr_posicao
from SAN_TES_ESP_GER_ANT_ISBT
where coalesce(dt_inativacao::text, '') = '';


BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	SELECT San_Gerar_Codigo_ISBT.san_obter_fenotipagem_concat(nr_seq_doacao_p, 1)
		into STRICT ds_fenotipagem_w
	;

	if (ds_fenotipagem_w IS NOT NULL AND ds_fenotipagem_w::text <> '') then

		open c01;
		loop
		fetch c01 into
			ds_antigeno1_w,
			ds_antigeno2_w,
			nr_posicao_ant_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (nr_posicao_ant_w = 2) then
			ds_ant1_pos_2_w := ds_antigeno1_w;
			ds_ant2_pos_2_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 3) then
			ds_ant1_pos_3_w := ds_antigeno1_w;
			ds_ant2_pos_3_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 4) then
			ds_ant1_pos_4_w := ds_antigeno1_w;
			ds_ant2_pos_4_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 5) then
			ds_ant1_pos_5_w := ds_antigeno1_w;
			ds_ant2_pos_5_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 6) then
			ds_ant1_pos_6_w := ds_antigeno1_w;
			ds_ant2_pos_6_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 7) then
			ds_ant1_pos_7_w := ds_antigeno1_w;
			ds_ant2_pos_7_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 8) then
			ds_ant1_pos_8_w := ds_antigeno1_w;
			ds_ant2_pos_8_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 9) then
			ds_ant1_pos_9_w := ds_antigeno1_w;
			ds_ant2_pos_9_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 10) then
			ds_ant1_pos_10_w := ds_antigeno1_w;
			ds_ant2_pos_10_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 11) then
			ds_ant1_pos_11_w := ds_antigeno1_w;
			ds_ant2_pos_11_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 12) then
			ds_ant1_pos_12_w := ds_antigeno1_w;
			ds_ant2_pos_12_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 13) then
			ds_ant1_pos_13_w := ds_antigeno1_w;
			ds_ant2_pos_13_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 14) then
			ds_ant1_pos_14_w := ds_antigeno1_w;
			ds_ant2_pos_14_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 15) then
			ds_ant1_pos_15_w := ds_antigeno1_w;
			ds_ant2_pos_15_w := ds_antigeno2_w;
		end if;

		if (nr_posicao_ant_w = 16) then
			ds_ant1_pos_16_w := ds_antigeno1_w;
		end if;

		end;
		end loop;
		close c01;

		while((ds_fenotipagem_w IS NOT NULL AND ds_fenotipagem_w::text <> '') or trim(both ds_fenotipagem_w) <> '') loop

			ie_entrou_w := 'N';
			nr_posicao_str_w := position(', ' in ds_fenotipagem_w);

			if (nr_posicao_str_w = 0) then
				ds_fenotipo_w := trim(both ds_fenotipagem_w);
				ds_fenotipagem_w := null;
			else
				ds_fenotipo_w := substr(ds_fenotipagem_w, 1, nr_posicao_str_w - 1);
				ds_fenotipagem_w := substr(ds_fenotipagem_w, nr_posicao_str_w + 2);
			end if;

			if (ds_fenotipo_w = 'C+' or  ds_fenotipo_w = 'C-' or
				ds_fenotipo_w = 'c+' or ds_fenotipo_w = 'c-' or
				ds_fenotipo_w = 'E+' or ds_fenotipo_w = 'E-' or
				ds_fenotipo_w = 'e+' or ds_fenotipo_w = 'e-'
				or ds_fenotipo_w = 'c_T' or ds_fenotipo_w = 'C_T'
				or ds_fenotipo_w = 'E_T' or ds_fenotipo_w = 'e_T') then
				ds_posicao1_w := ds_posicao1_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_2_w || '+' or ds_fenotipo_w = ds_ant1_pos_2_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_2_w || '+' or ds_fenotipo_w = ds_ant2_pos_2_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_2_w || '_T' or ds_fenotipo_w = ds_ant2_pos_2_w || '_T') then
				ds_posicao2_w := ds_posicao2_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_3_w || '+' or ds_fenotipo_w = ds_ant1_pos_3_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_3_w || '+' or ds_fenotipo_w = ds_ant2_pos_3_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_3_w || '_T' or ds_fenotipo_w = ds_ant2_pos_3_w || '_T') then
				ds_posicao3_w := ds_posicao3_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_4_w || '+' or ds_fenotipo_w = ds_ant1_pos_4_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_4_w || '+' or ds_fenotipo_w = ds_ant2_pos_4_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_4_w || '_T' or ds_fenotipo_w = ds_ant2_pos_4_w || '_T') then
				ds_posicao4_w := ds_posicao4_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_5_w || '+' or ds_fenotipo_w = ds_ant1_pos_5_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_5_w || '+' or ds_fenotipo_w = ds_ant2_pos_5_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_5_w || '_T' or ds_fenotipo_w = ds_ant2_pos_5_w || '_T') then
				ds_posicao5_w := ds_posicao5_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_6_w || '+' or ds_fenotipo_w = ds_ant1_pos_6_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_6_w || '+' or ds_fenotipo_w = ds_ant2_pos_6_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_6_w || '_T' or ds_fenotipo_w = ds_ant2_pos_6_w || '_T') then
				ds_posicao6_w := ds_posicao6_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_7_w || '+' or ds_fenotipo_w = ds_ant1_pos_7_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_7_w || '+' or ds_fenotipo_w = ds_ant2_pos_7_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_7_w || '_T' or ds_fenotipo_w = ds_ant2_pos_7_w || '_T') then
				ds_posicao7_w := ds_posicao7_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_8_w || '+' or ds_fenotipo_w = ds_ant1_pos_8_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_8_w || '+' or ds_fenotipo_w = ds_ant2_pos_8_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_8_w || '_T' or ds_fenotipo_w = ds_ant2_pos_8_w || '_T') then
				ds_posicao8_w := ds_posicao8_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_9_w || '+' or ds_fenotipo_w = ds_ant1_pos_9_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_9_w || '+' or ds_fenotipo_w = ds_ant2_pos_9_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_9_w || '_T' or ds_fenotipo_w = ds_ant2_pos_9_w || '_T') then
				ds_posicao9_w := ds_posicao9_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_10_w || '+' or ds_fenotipo_w = ds_ant1_pos_10_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_10_w || '+' or ds_fenotipo_w = ds_ant2_pos_10_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_10_w || '_T' or ds_fenotipo_w = ds_ant2_pos_10_w || '_T') then
				ds_posicao10_w := ds_posicao10_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_11_w || '+' or ds_fenotipo_w = ds_ant1_pos_11_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_11_w || '+' or ds_fenotipo_w = ds_ant2_pos_11_w || '-'
				or ds_fenotipo_w = ds_ant1_pos_11_w || '_T' or ds_fenotipo_w = ds_ant2_pos_11_w || '_T') then
				ds_posicao11_w := ds_posicao11_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_12_w || '+' or ds_fenotipo_w = ds_ant1_pos_12_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_12_w || '+' or ds_fenotipo_w = ds_ant2_pos_12_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_12_w || '_T' or ds_fenotipo_w = ds_ant2_pos_12_w || '_T') then
				ds_posicao12_w := ds_posicao12_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_13_w || '+' or ds_fenotipo_w = ds_ant1_pos_13_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_13_w || '+' or ds_fenotipo_w = ds_ant2_pos_13_w || '-'
				or ds_fenotipo_w = ds_ant1_pos_13_w || '_T' or ds_fenotipo_w = ds_ant2_pos_13_w || '_T') then
				ds_posicao13_w := ds_posicao13_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_14_w || '+' or ds_fenotipo_w = ds_ant1_pos_14_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_14_w || '+' or ds_fenotipo_w = ds_ant2_pos_14_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_14_w || '_T' or ds_fenotipo_w = ds_ant2_pos_14_w || '_T') then
				ds_posicao14_w := ds_posicao14_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_15_w || '+' or ds_fenotipo_w = ds_ant1_pos_15_w || '-' or
				ds_fenotipo_w = ds_ant2_pos_15_w || '+' or ds_fenotipo_w = ds_ant2_pos_15_w || '-' 
				or ds_fenotipo_w = ds_ant1_pos_15_w || '_T' or ds_fenotipo_w = ds_ant2_pos_15_w || '_T') then
				ds_posicao15_w := ds_posicao15_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ds_fenotipo_w = ds_ant1_pos_16_w || '+' or ds_fenotipo_w = ds_ant1_pos_16_w || '-' or ds_fenotipo_w = ds_ant1_pos_16_w || '_T') then
				ds_posicao16_w := ds_posicao16_w || ds_fenotipo_w;
				ie_entrou_w := 'S';
			end if;

			if (ie_entrou_w = 'N' and coalesce(ds_posicao17_18_w::text, '') = '') then
				select max(vl_valor)
					into STRICT ds_posicao17_18_w
				from SAN_TES_ESP_ANT_ESPEC_ISBT
				where ie_situacao = 'A'
				and obter_valor_dominio(9620,cd_antigeno) || '-' = ds_fenotipo_w;
			end if;

		end loop;

	if (ds_posicao1_w IS NOT NULL AND ds_posicao1_w::text <> '') then

		select max(vl_valor)
			into STRICT ds_posicao1_w
		from SAN_TES_ESP_ANT_RES_ISBT
		where coalesce(dt_inativacao::text, '') = ''
		and cd_resultado_rh = ds_posicao1_w;

    if (coalesce(ds_posicao1_w::text, '') = '') then
	ds_posicao1_w := '0T';
    end if;

	end if;

end if;

	ds_posicao2_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao2_w, ds_ant1_pos_2_w, ds_ant2_pos_2_w);
	ds_posicao3_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao3_w, ds_ant1_pos_3_w, ds_ant2_pos_3_w);
	ds_posicao4_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao4_w, ds_ant1_pos_4_w, ds_ant2_pos_4_w);
	ds_posicao5_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao5_w, ds_ant1_pos_5_w, ds_ant2_pos_5_w);
	ds_posicao6_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao6_w, ds_ant1_pos_6_w, ds_ant2_pos_6_w);
	ds_posicao7_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao7_w, ds_ant1_pos_7_w, ds_ant2_pos_7_w);
	ds_posicao8_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao8_w, ds_ant1_pos_8_w, ds_ant2_pos_8_w);
	ds_posicao9_w  := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao9_w, ds_ant1_pos_9_w, ds_ant2_pos_9_w);
	ds_posicao10_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao10_w, ds_ant1_pos_10_w, ds_ant2_pos_10_w);
	ds_posicao11_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao11_w, ds_ant1_pos_11_w, ds_ant2_pos_11_w);
	ds_posicao12_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao12_w, ds_ant1_pos_12_w, ds_ant2_pos_12_w);
	ds_posicao13_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao13_w, ds_ant1_pos_13_w, ds_ant2_pos_13_w);
	
	if (coalesce(ds_posicao1_w::text, '') = '' or ds_posicao1_w = '9') then
		ds_posicao14_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao14_w, ds_ant1_pos_14_w, ds_ant2_pos_14_w);
		ds_posicao15_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao15_w, ds_ant1_pos_15_w, ds_ant2_pos_15_w);
		ds_posicao16_w := San_Gerar_Codigo_ISBT.san_obter_vlpos_antigeno(ds_posicao16_w, ds_ant1_pos_16_w, null);
		if (ds_posicao1_w = '9' or coalesce(ds_posicao1_w::text, '') = '') then
			ds_posicao1_w := '9';
		else
			ds_posicao1_w := '0';
		end if;
	else
		if (ds_posicao1_w = '0T') then
			ds_posicao1_w := '0';
		end if;

		ds_posicao14_w := '9';
		ds_posicao15_w := '9';
		ds_posicao16_w := '9';
	end if;

end if;

ds_fenotipagem_w := ds_posicao1_w || ds_posicao2_w || ds_posicao3_w || ds_posicao4_w || ds_posicao5_w || ds_posicao6_w || ds_posicao7_w || ds_posicao8_w ||
			ds_posicao9_w || ds_posicao10_w || ds_posicao11_w || ds_posicao12_w || ds_posicao13_w || ds_posicao14_w || ds_posicao15_w || ds_posicao16_w;

if (coalesce(ds_posicao17_18_w::text, '') = '') then
	ds_fenotipagem_w := ds_fenotipagem_w || '99';
else
	ds_fenotipagem_w := ds_fenotipagem_w || ds_posicao17_18_w;
end if;

if (ds_fenotipagem_w IS NOT NULL AND ds_fenotipagem_w::text <> '') then
	select max(nr_seq_doacao),
        	max(nr_seq_producao)
  	into STRICT  nr_seq_doacao_w,
        	nr_seq_producao_w
  	FROM
		san_result_fenotipagem
	WHERE (nr_seq_doacao = nr_seq_doacao_p or nr_seq_producao = nr_seq_doacao_p);

  if (nr_seq_doacao_w IS NOT NULL AND nr_seq_doacao_w::text <> '') then
   	update SAN_DOACAO
    	set cd_isbt_antigeno = ds_fenotipagem_w
    	where nr_sequencia = nr_seq_doacao_w;
  else
    	update SAN_PRODUCAO
    	set cd_isbt_antigeno = ds_fenotipagem_w
    	where nr_sequencia = nr_seq_producao_w;
  end if;

	commit;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_codigo_isbt.san_gravar_cod_isbt_fenot ( nr_seq_doacao_p bigint) FROM PUBLIC;