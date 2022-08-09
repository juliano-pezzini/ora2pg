-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_import_resultados ( cd_barra_p text, ds_sigla_integracao_p text, ie_tipo_conteudo_p text, ds_conteudo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_lote_w	bigint;
nr_seq_doacao_w		bigint;
nr_seq_exame_w		bigint;
dt_util_w		timestamp;
ds_resultado_w		varchar(255) := '';
ds_abs_w		varchar(255) := '';
ds_kit_w		varchar(20) := '';
nr_Seq_kit_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from 	san_exame
	where	trim(both upper(ds_sigla_integracao)) = trim(both upper(ds_sigla_integracao_p));



BEGIN
if (cd_barra_p IS NOT NULL AND cd_barra_p::text <> '') then

	select	max(c.nr_sequencia),
			max(c.nr_seq_doacao)
	into STRICT	nr_seq_exame_lote_w,
			nr_seq_doacao_w
	from	san_exame_realizado a,
			san_exame_lote c,
			san_doacao d,
			san_exame e
	where	a.nr_seq_exame_lote		= c.nr_sequencia 
	and		d.nr_sequencia		= c.nr_seq_doacao 
	and (lpad(d.cd_barras_integracao,20,'0') = rpad( cd_barra_p,20,' ')
	or		lpad(trim(both d.cd_barras_integracao),20,'0') = lpad( trim(both cd_barra_p),20,'0'))
	and		a.nr_seq_exame		= e.nr_sequencia 
	order by 1;

	if (coalesce(nr_seq_exame_lote_w,0) > 0) and (coalesce(nr_seq_doacao_w,0) > 0) then
		begin
		open C01;
		loop
		fetch C01 into	
			nr_seq_exame_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if		((ie_tipo_conteudo_p = 'DT') or (ie_tipo_conteudo_p = 'DTA') ) then	--data e hora da geracao do resultado
			
				dt_util_w	:= to_date(somente_numero_char(ds_conteudo_p),'ddmmyyyyhh24mi');
			
				update	san_exame_realizado
				set	dt_realizado		= dt_util_w
				where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
				and	nr_seq_exame		= nr_seq_exame_w;
				
			elsif (ie_tipo_conteudo_p = 'VL') then	--validade kit
		
				dt_util_w := to_date(somente_numero_char(ds_conteudo_p),'ddmmyyyy');
			
				update	san_exame_realizado
				set	dt_vencimento_lote	= dt_util_w
				where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
				and	nr_seq_exame		= nr_seq_exame_w;	
			
			elsif	((ie_tipo_conteudo_p = 'DO') or (ie_tipo_conteudo_p = 'IX') ) then	-- valor de Densidade etica
			
				update	san_exame_realizado
				set	nr_densidade_otica	= coalesce(to_number(ds_conteudo_p,'999999999999999.9999'),0)
				where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
				and	nr_seq_exame		= nr_seq_exame_w;
				
			elsif (ie_tipo_conteudo_p = 'CO') then	--valor de co
			
				update	san_exame_realizado
				set	nr_cutoff		= coalesce(to_number(ds_conteudo_p,'9999999999.9999'),0)
				where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
				and	nr_seq_exame		= nr_seq_exame_w;
				
			elsif (ie_tipo_conteudo_p = 'LT') then	--lote do kit 
				
				select	max(nr_sequencia),
					substr(max(ds_kit),1,20)
				into STRICT 	nr_Seq_kit_w,
					ds_kit_w
				from	san_kit_exame
				where	nr_Seq_exame		= nr_seq_exame_w
				and	trim(both upper(ds_lote_kit)) = trim(both upper(ds_conteudo_p))
				and	clock_timestamp() between dt_vigencia_ini and dt_vigencia_final
        and ie_exame_interno = 'N';

				if (coalesce(nr_Seq_kit_w,0) > 0) then
					
					update	san_exame_realizado
					set	nr_kit_lote		= nr_Seq_kit_w,
						ds_lote_kit		= coalesce(ds_kit_w, ds_lote_kit)
					where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
					and	nr_seq_exame		= nr_seq_exame_w;			
				
				end if;
				
			elsif	((ie_tipo_conteudo_p = 'RE') or (ie_tipo_conteudo_p = 'RES')) then	--resultado interpretativo
				
				if (ds_conteudo_p = 'NR') then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(309101); -- Nao reagente
					ds_abs_w	:= 'NR';
					
				elsif ((ds_conteudo_p = 'AN') or (ds_conteudo_p = 'AND')) then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(309637); -- Andamento
					ds_abs_w	:= 'AN';
					
					update	san_exame_realizado
					set	ie_andamento		= 'S'
					where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
					and	nr_seq_exame		= nr_seq_exame_w;
					
				elsif (ds_conteudo_p = 'SR') then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(309098); -- Reagente
					ds_abs_w		:= 'R';
					
				elsif (ds_conteudo_p = 'IN') then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(329914); -- Indeterminado/inconclusivo
					ds_abs_w		:= 'IN';
					
				elsif ((ds_conteudo_p = 'A') or (ds_conteudo_p = 'B') or (ds_conteudo_p = 'AB') or (ds_conteudo_p = 'O')) then
					ds_resultado_w	:= ds_conteudo_p;
					ds_abs_w		:= ds_conteudo_p;
					
				elsif (ds_conteudo_p = 'P') then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(329981); -- Positivo
					ds_abs_w		:= 'P';
					
				elsif (ds_conteudo_p = 'N') then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(329984); -- Negativo
					ds_abs_w		:= 'N';
					
				elsif (ds_conteudo_p = 'IV') then
					ds_resultado_w	:= wheb_mensagem_pck.get_texto(330081); -- Invalido
					ds_abs_w		:= 'IV';
					
				end if;
				
				if (ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') then
				
					update	san_exame_realizado
					set	ds_resultado		= ds_resultado_w,
						ds_abs			= ds_abs_w,
						nr_cutoff		= coalesce(nr_cutoff,1.000)
					where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
					and	nr_seq_exame		= nr_seq_exame_w;
				else
					update	san_exame_realizado
					set	ds_abs			= substr(ds_conteudo_p,1,255)
					where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
					and	nr_seq_exame		= nr_seq_exame_w;
					
				end if;
			
			elsif (ie_tipo_conteudo_p = 'OB') then	--observacao da Central para a amostra analisada 
					update	san_exame_realizado
					set	ds_justificativa	= ds_conteudo_p
					where 	nr_seq_exame_lote	= nr_seq_exame_lote_w
					and	nr_seq_exame		= nr_seq_exame_w;
			end if;
			end;
		end loop;
		close C01;
		
		exception
		when others then
			null;
		end;
	end if;
end if;
								
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_import_resultados ( cd_barra_p text, ds_sigla_integracao_p text, ie_tipo_conteudo_p text, ds_conteudo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
