-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_planejamento_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_local_p bigint, nr_seq_servico_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w		timestamp;
nr_seq_servico_w	bigint;
nr_Sequencia_w		bigint;
nr_seq_opcao_w		bigint;
NR_SEQ_COMP_w		bigint;
nr_seq_receitao_w	bigint;
nr_Seq_nut_cardapio_w	bigint;	
qt_refeicao_w		bigint;
qt_pessoa_atend_w	bigint;	
nr_seq_local_w		bigint;
ds_parametro_w		varchar(2);
ie_servico_diario_w	varchar(1);
nr_seq_grupo_producao_w	bigint;
cd_dieta_w 		bigint;
ds_parametro_120_w  	varchar(1);

C01 CURSOR FOR
	SELECT	dt_inicial_p+(rownum-1) dt_referencia
	from	tabela_sistema ORDER by dt_referencia LIMIT (obter_Somente_numero(( dt_final_p - dt_inicial_p )+1));		

C02 CURSOR FOR
	SELECT  x.nr_Seq_servico,
		x.qt_pessoa_atend,
		x.nr_seq_local,
		x.nr_seq_grupo_producao,
		x.cd_dieta
	FROM    nut_receita c,
		nut_cardapio a,
		nut_cardapio_dia x,
		nut_servico b
	WHERE   a.nr_seq_receita    = c.nr_sequencia
	AND     ((nr_seq_servico_p = 0) or (x.nr_seq_servico = nr_seq_servico_p))
	AND     a.nr_seq_card_dia   = x.nr_sequencia
	AND     x.cd_estabelecimento = cd_estabelecimento_p
	AND 	x.nr_seq_servico = b.nr_sequencia
	AND 	b.cd_estabelecimento = cd_estabelecimento_p			
	AND     ((coalesce(nr_seq_local_p,0) = 0) OR (x.nr_seq_local = nr_seq_local_p))
	AND     ((ds_parametro_120_w = 'N' and (dt_referencia_w BETWEEN x.dt_vigencia_inicial AND x.dt_vigencia_final)) 
         or (ds_parametro_120_w='S' and coalesce(x.nr_seq_cycle,0) > 0 and get_cycle_day(dt_referencia_w, x.nr_seq_cycle) = x.nr_seq_cycle_day))
	group by x.nr_seq_servico,
		x.qt_pessoa_atend,
		x.nr_seq_local,
		x.nr_seq_grupo_producao,
		x.cd_dieta
	HAVING max(Obter_se_cardapio_dia(dt_referencia_w, x.ie_semana, x.ie_dia_semana)) = 'S';

C03 CURSOR FOR
	SELECT  x.nr_seq_opcao,
		a.NR_SEQ_COMP,
		c.nr_sequencia,
		a.nr_sequencia,
		a.qt_refeicao
	FROM    nut_receita c,
		nut_cardapio a,
		nut_cardapio_dia x,
		nut_servico b
	WHERE   a.nr_seq_receita    = c.nr_sequencia
	AND     x.nr_seq_servico = nr_Seq_servico_w
	AND	coalesce(x.qt_pessoa_atend,0) = coalesce(qt_pessoa_atend_w,0)
	AND     a.nr_seq_card_dia   = x.nr_sequencia
	AND     x.cd_estabelecimento = cd_estabelecimento_p
	AND 	x.nr_seq_servico = b.nr_sequencia
	AND 	b.cd_estabelecimento = cd_estabelecimento_p
	AND     ((coalesce(nr_seq_local_w,0) = 0) OR (x.nr_seq_local = nr_seq_local_w))
	and	((coalesce(nr_seq_grupo_producao_w,0) = 0) OR (x.nr_seq_grupo_producao = nr_seq_grupo_producao_w))
	AND	((coalesce(cd_dieta_w, 0) = 0) or (x.cd_dieta = cd_dieta_w))
	AND     ((ds_parametro_120_w = 'N' and (dt_referencia_w BETWEEN x.dt_vigencia_inicial AND x.dt_vigencia_final AND  Obter_se_cardapio_dia(dt_referencia_w, x.ie_semana, x.ie_dia_semana) = 'S'))
         or (ds_parametro_120_w='S' and coalesce(x.nr_seq_cycle,0) > 0 and get_cycle_day(dt_referencia_w, x.nr_seq_cycle) = x.nr_seq_cycle_day));

C04 CURSOR FOR
	SELECT  a.NR_SEQ_COMP,
		c.nr_sequencia,
		sum(a.qt_refeicao)
	FROM    nut_receita c,
		nut_cardapio a,
		nut_cardapio_dia x,
		nut_servico b
	WHERE   a.nr_seq_receita    = c.nr_sequencia
	AND     a.nr_seq_card_dia   = x.nr_sequencia
	AND     x.cd_estabelecimento = cd_estabelecimento_p
	AND 	x.nr_seq_servico = b.nr_sequencia
	AND 	b.cd_estabelecimento = cd_estabelecimento_p
	AND     ((nr_seq_servico_p = 0) or (x.nr_seq_servico = nr_seq_servico_p))
	AND     ((coalesce(nr_seq_local_w,0) = 0) OR (x.nr_seq_local = nr_seq_local_w))
	AND     ((ds_parametro_120_w = 'N' and (dt_referencia_w BETWEEN x.dt_vigencia_inicial AND x.dt_vigencia_final AND  Obter_se_cardapio_dia(dt_referencia_w, x.ie_semana, x.ie_dia_semana) = 'S'))
         or (ds_parametro_120_w='S' and coalesce(x.nr_seq_cycle,0) > 0 and get_cycle_day(dt_referencia_w, x.nr_seq_cycle) = x.nr_seq_cycle_day))
	group by a.NR_SEQ_COMP,
		c.nr_sequencia;


BEGIN

ds_parametro_w := obter_valor_param_usuario(1003,89,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
ie_servico_diario_w := Nut_obter_se_serv_diario(nr_seq_servico_p);
ds_parametro_120_w := obter_valor_param_usuario(1003,120,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
nr_seq_local_w := nr_seq_local_p;
open c01;
loop
fetch c01 into dt_referencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin


	if (ie_servico_diario_w = 'N') then

		open c02;
		loop
		fetch c02 into 	nr_seq_servico_w,
				qt_pessoa_atend_w,
				nr_seq_local_w,
				nr_seq_grupo_producao_w,
				cd_dieta_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin



			select	nextval('nut_cardapio_dia_seq')
			into STRICT	nr_Sequencia_w
			;

			if (ds_parametro_w = 'N') then
				nr_seq_local_w := nr_seq_local_p;
			end if;

			insert into nut_cardapio_dia(	nr_sequencia,
							dt_cardapio,
							nr_seq_servico,
							nr_seq_local,
							ie_tipo_cardapio,
							cd_estabelecimento,
							nm_usuario,
							dt_atualizacao,
							qt_pessoa_atend,
							nr_seq_grupo_producao,
							cd_dieta)
					values (	nr_Sequencia_w,
							dt_referencia_w,
							nr_seq_servico_w,
							nr_seq_local_w,
							'PL',
							cd_estabelecimento_p,
							nm_usuario_p,
							clock_timestamp(),
							qt_pessoa_atend_w,
							nr_seq_grupo_producao_w,
							cd_dieta_w);

			open c03;
			loop		
			fetch c03 into 	nr_seq_opcao_w,
					nr_seq_comp_w,
					nr_seq_receitao_w,
					nr_Seq_nut_cardapio_w,
					qt_refeicao_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin

				CALL Nut_Gerar_Pac_Opcao_rec(nr_seq_opcao_w,nr_seq_comp_w,nr_seq_receitao_w,null,'N',null,null,nr_Sequencia_w,nr_Seq_nut_cardapio_w,qt_refeicao_w, nm_usuario_p,null);

				end;
			end loop;
			close c03;			

			end;
		end loop;
		close c02;
	else

		select	nextval('nut_cardapio_dia_seq')
		into STRICT	nr_Sequencia_w
		;

		insert into nut_cardapio_dia(	nr_sequencia,
						dt_cardapio,
						nr_seq_servico,
						nr_seq_local,
						ie_tipo_cardapio,
						cd_estabelecimento,
						nm_usuario,
						dt_atualizacao,
						qt_pessoa_atend)
				values (	nr_Sequencia_w,
						dt_referencia_w,
						nr_seq_servico_p,
						nr_seq_local_p,
						'PL',
						cd_estabelecimento_p,
						nm_usuario_p,
						clock_timestamp(),
						null);

		open c04;
		loop		
		fetch c04 into 	nr_seq_comp_w,
				nr_seq_receitao_w,
				qt_refeicao_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin

			CALL Nut_Gerar_Pac_Opcao_rec(null,nr_seq_comp_w,nr_seq_receitao_w,null,'N',null,null,nr_Sequencia_w,null,qt_refeicao_w, nm_usuario_p,null);

			end;
		end loop;
		close c04;

	end if;
	end;
end loop;
close c01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_planejamento_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_local_p bigint, nr_seq_servico_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
