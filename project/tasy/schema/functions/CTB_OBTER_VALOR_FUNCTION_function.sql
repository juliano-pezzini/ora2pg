-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_valor_function ( nr_seq_demo_p bigint, nr_seq_mes_ref_p bigint, ds_origem_p text, nr_seq_col_p bigint) RETURNS bigint AS $body$
DECLARE


ds_origem_w			varchar(4000);
ds_regra_w			varchar(100);
vl_saldo_w			double precision;
vl_result_w			double precision;
nr_seq_w			bigint;
qt_rubrica_w			bigint	:= 0;
ie_pos_par_esq_w		integer;
ie_pos_par_dir_w		integer;
ie_pos_virgula_w		integer;
ie_pos_regra_w			integer;
nm_objeto_w			varchar(30);
ds_valores_w			varchar(4000);
ds_operacao_adic_w		varchar(4000);
qt_tamanho_w			bigint;
i				integer;
ie_caracter_w			varchar(1);


BEGIN

ds_origem_w			:= ds_origem_p;
ds_origem_w			:= replace(ds_origem_w,' ','');
qt_tamanho_w			:= length(ds_origem_w);
ds_valores_w			:= ds_origem_w;
vl_result_w			:= 0;
ie_pos_par_esq_w			:= position('(' in ds_origem_w);
ie_pos_par_dir_w			:= position(')' in ds_origem_w);
nm_objeto_w			:= substr(ds_origem_w,1,ie_pos_par_esq_w-1);
ds_origem_w			:= substr(ds_origem_w,ie_pos_par_esq_w+1,ie_pos_par_dir_w-(ie_pos_par_esq_w+1));

if (nm_objeto_w IS NOT NULL AND nm_objeto_w::text <> '') then
	ds_valores_w	:= '';
	while(length(ds_origem_w) > 0)  loop
		nr_seq_w		:= null;
		ie_pos_virgula_w	:= coalesce(position(',' in ds_origem_w),0);
		if (ie_pos_virgula_w > 0) then
			nr_seq_w	:= campo_numerico(substr(ds_origem_w,1, ie_pos_virgula_w - 1));

		else
			nr_seq_w	:= campo_numerico(ds_origem_w);
			ds_origem_w	:= '';
		end if;
		ds_origem_w		:= substr(ds_origem_w, ie_pos_virgula_w +1, 4000);

		vl_saldo_w	:= 0;

		if (coalesce(nr_seq_w,0) > 0) then


			select coalesce(sum(vl_referencia),0)
			into STRICT	vl_saldo_w
			from	ctb_demo_rubrica
			where	nr_seq_mes_ref	= nr_seq_mes_ref_p
			and	nr_seq_demo	= nr_seq_demo_p
			and	nr_seq_rubrica	= nr_seq_w
			and	nr_seq_col	= nr_seq_col_p;

			ds_valores_w	:= ds_valores_w || replace(vl_saldo_w,',','.');
			if (length(ds_origem_w) > 0) then
				ds_valores_w := ds_valores_w  || ',';
			end if;

		end if;
	end loop;
else

	for i in 1..qt_tamanho_w loop
		begin
		/* Caracter */

		ie_caracter_w	:= substr(ds_origem_w,i,1);

		if (ie_caracter_w = '#') then
			ie_pos_regra_w	:= i;
		elsif (ie_caracter_w in ('0','1','2','3','4','5','6','7','8','9')) then /* Numeros valor fixo ou Seq formula*/
			ds_regra_w	:= ds_regra_w || ie_caracter_w;
		end if;

		/* Verifica se tem valor a calcular */

		if	((ie_caracter_w not in ('0','1','2','3','4','5','6','7','8','9','#')) or (i = qt_tamanho_w)) and (ds_regra_w IS NOT NULL AND ds_regra_w::text <> '') then
			begin
			if (ie_pos_regra_w <> 0) and /* Calcula valor da regra */
				(ie_pos_regra_w < i) then
				begin
				nr_seq_w	:= campo_numerico(ds_regra_w);
				select coalesce(sum(vl_referencia),0)
				into STRICT	vl_saldo_w
				from	ctb_demo_rubrica
				where	nr_seq_mes_ref	= nr_seq_mes_ref_p
				and	nr_seq_demo	= nr_seq_demo_p
				and	nr_seq_rubrica	= nr_seq_w
				and	nr_seq_col	= nr_seq_col_p;
				exception when others then
					vl_saldo_w	:= 0;
				end;
				ds_regra_w	:= '#' || ds_regra_w;
				ie_pos_regra_w	:= 0;
			else /* Valor fixo*/
				vl_saldo_w	:= campo_numerico(ds_regra_w);
			end if;
			/* Substitui valor na expressão correspondente */

			ds_valores_w	:= replace(ds_valores_w,ds_regra_w,replace(vl_saldo_w,',','.'));
			ds_regra_w	:= '';
			end;
		end if;

		end;
	end loop;
end if;

if (substr(ds_valores_w,1,length(ds_valores_w)) = ',') then
	ds_valores_w	:= substr(ds_valores_w,1,length(ds_valores_w)-1);
end if;
vl_result_w := obter_valor_dinamico('select ' || nm_objeto_w || '(' || ds_valores_w || ') from dual', vl_result_w);

return	vl_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_valor_function ( nr_seq_demo_p bigint, nr_seq_mes_ref_p bigint, ds_origem_p text, nr_seq_col_p bigint) FROM PUBLIC;
