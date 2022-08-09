-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_verificar_aviso_camara ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_comunic_w		bigint;
nr_seq_regra_data_w		bigint;
nr_seq_camara_w			bigint;
nr_seq_camara_comp_w		bigint;
nr_seq_calendario_w		bigint;
ds_mensagem_w			varchar(4000);
ds_conteudo_w			varchar(4500);
ie_data_calendario_w		varchar(3);
qt_dia_antecedente_w		integer;
ie_aviso_continuo_w		varchar(1);
cd_perfil_w			bigint;
nm_usuario_dest_w		varchar(15);
ie_email_w			varchar(1);
ie_comunic_interna_w		varchar(1);
dt_calendario_w			timestamp;
nr_seq_camara_dest_w		bigint;
nr_ano_w			smallint;
qt_dias_w			integer;
ds_data_calendario_w		varchar(255);
ds_camara_w			varchar(255);
ds_email_origem_w		varchar(255);
ds_email_destino_w		varchar(255);
ds_titulo_w			varchar(255);
dt_referencia_w			timestamp;
nr_camara_w			smallint;
ds_camara_mens_w		varchar(12);
nr_mes_w			smallint;
ds_mes_w			varchar(9);

C01 CURSOR FOR	/* Cursor dad regras */
	SELECT	a.nr_sequencia,
		a.nr_seq_camara,
		a.ds_mensagem
	from	pls_regra_comunic_camara	a
	where	a.ie_situacao	= 'A';

C02 CURSOR FOR	/* Cursor das datas das regras */
	SELECT	a.nr_sequencia,
		a.ie_data_calendario,
		a.qt_dia_antecedente,
		a.ie_aviso_continuo
	from	pls_regra_com_camara_data	a
	where	a.nr_seq_regra_comunic	= nr_seq_regra_comunic_w;

C03 CURSOR FOR	/* Cursor dos destinatarios das regras */
	SELECT	a.nr_sequencia,
		a.cd_perfil,
		a.nm_usuario_dest,
		a.ie_email,
		a.ie_comunic_interna
	from	pls_regra_com_camara_dest	a
	where	a.nr_seq_regra_data	= nr_seq_regra_data_w;


BEGIN
nr_ano_w := (to_char(dt_referencia_p,'yyyy'))::numeric;

/* Cursor das regras */

open C01;
loop
fetch C01 into
	nr_seq_regra_comunic_w,
	nr_seq_camara_w,
	ds_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/* Câmara ativa referente a da regra */

	select	a.nr_sequencia
	into STRICT	nr_seq_camara_comp_w
	from	pls_camara_compensacao	a
	where	a.nr_sequencia	= nr_seq_camara_w
	and	a.ie_situacao	= 'A';

	/* Verifica se a data de referência (nr_ano) se esta de acordo*/

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_calendario_w
	from	pls_camara_calendario	a
	where	a.nr_seq_camara	= nr_seq_camara_comp_w
	and	a.nr_ano	= nr_ano_w;

	/* Cursor das datas das regras */

	open C02;
	loop
	fetch C02 into
		nr_seq_regra_data_w,
		ie_data_calendario_w,
		qt_dia_antecedente_w,
		ie_aviso_continuo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		dt_referencia_w := trunc(dt_referencia_p,'dd');

		/* Verifica as datas de acordo com o valor do dominio 4772 */

		if (ie_data_calendario_w = '1') then -- Data limite A500
			select	max(a.dt_limite_a500),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_limite_a500)= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_limite_a500 - qt_dia_antecedente_w and dt_limite_a500 -1));

		elsif (ie_data_calendario_w = '2') then -- Data limite A600
			select	max(a.dt_limite_a600),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_limite_a600)= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_limite_a600 - qt_dia_antecedente_w and dt_limite_a600 -1));

		elsif (ie_data_calendario_w = '3') then -- Data prévia
			select	max(a.dt_previa),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_previa)	= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_previa - qt_dia_antecedente_w and a.dt_previa -1));

		elsif (ie_data_calendario_w = '4') then -- Data limite exclusão
			select	max(a.dt_limite_exclusao),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario		= nr_seq_calendario_w
			and (trunc(a.dt_limite_exclusao)	= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w		= 'S'
			and	dt_referencia_w between a.dt_limite_exclusao - qt_dia_antecedente_w and a.dt_limite_exclusao -1));

		elsif (ie_data_calendario_w = '5') then -- Data saldo credor
			select	max(a.dt_saldo_credor),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario		= nr_seq_calendario_w
			and (trunc(a.dt_saldo_credor)	= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w		= 'S'
			and	dt_referencia_w between a.dt_saldo_credor - qt_dia_antecedente_w and a.dt_saldo_credor -1));

		elsif (ie_data_calendario_w = '6') then -- Data saldo devedor
			select	max(a.dt_saldo_devedor),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario		= nr_seq_calendario_w
			and (trunc(a.dt_saldo_devedor)	= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w		= 'S'
			and	dt_referencia_w between a.dt_saldo_devedor - qt_dia_antecedente_w and a.dt_saldo_devedor -1));

		elsif (ie_data_calendario_w = '7') then -- Data limite documentação
			select	max(a.dt_limite_rec_doc),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario		= nr_seq_calendario_w
			and (trunc(a.dt_limite_rec_doc)	= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w		= 'S'
			and	dt_referencia_w between a.dt_limite_rec_doc - qt_dia_antecedente_w and a.dt_limite_rec_doc -1));

		elsif (ie_data_calendario_w = '8') then -- Data definitivo
			select	max(a.dt_definitivo),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_definitivo)	= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_definitivo - qt_dia_antecedente_w and a.dt_definitivo -1));

		elsif (ie_data_calendario_w = '9') then -- Data limite A550
			select	max(a.dt_limite_a550),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_limite_a550)= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_limite_a550 - qt_dia_antecedente_w and dt_limite_a550 -1));

		elsif (ie_data_calendario_w = '10') then -- Data repasse
			select	max(a.dt_repasse),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_repasse)= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_repasse - qt_dia_antecedente_w and dt_repasse -1));

		elsif (ie_data_calendario_w = '11') then -- Data limite cancelamento A550
			select	max(a.dt_limite_canc_a550),
				max(a.nr_camara),
				max(a.nr_mes)
			into STRICT	dt_calendario_w,
				nr_camara_w,
				nr_mes_w
			from	pls_camara_calend_periodo	a
			where	a.nr_seq_calendario	= nr_seq_calendario_w
			and (trunc(a.dt_limite_canc_a550)= dt_referencia_w + qt_dia_antecedente_w
			or (ie_aviso_continuo_w	= 'S'
			and	dt_referencia_w between a.dt_limite_canc_a550 - qt_dia_antecedente_w and dt_limite_canc_a550-1));

		end if;

		case	nr_camara_w
			when	1	then ds_camara_mens_w := 'Primeira de ';
			when	2	then ds_camara_mens_w := 'Segunda de ';
			when 	3	then ds_camara_mens_w := 'Terceira de ';
			else		ds_camara_mens_w := null;
		end case;

		case	nr_mes_w
			when	1	then ds_mes_w := 'Janeiro';
			when	2	then ds_mes_w := 'Fevereiro';
			when 	3	then ds_mes_w := 'Março';
			when	4	then ds_mes_w := 'Abril';
			when	5	then ds_mes_w := 'Maio';
			when 	6	then ds_mes_w := 'Junho';
			when	7	then ds_mes_w := 'Julho';
			when	8	then ds_mes_w := 'Agosto';
			when 	9	then ds_mes_w := 'Setembro';
			when	10	then ds_mes_w := 'Outubro';
			when	11	then ds_mes_w := 'Novembro';
			when 	12	then ds_mes_w := 'Dezembro';
			else		ds_mes_w := null;
		end case;

		/* Se obtve retorno é gerado mensagem e enviado aos destinatarios */

		if (dt_calendario_w IS NOT NULL AND dt_calendario_w::text <> '') then
			ds_data_calendario_w := substr(obter_valor_dominio(4772,ie_data_calendario_w),1,255);

			ds_camara_w := substr(pls_obter_desc_camara_comp(nr_seq_camara_w),1,255);

			qt_dias_w := trunc(dt_calendario_w,'dd') - trunc(dt_referencia_p,'dd');

			ds_titulo_w := 'Aviso de data da Câmara de Compensação';

			/* Conteudo a ser enviado */

			if (qt_dias_w = 0) then
				ds_conteudo_w := substr(ds_mensagem_w ||
						' Estamos no dia da "' || ds_data_calendario_w ||
						'" da câmara ' || ds_camara_w ||' '|| ds_camara_mens_w || ds_mes_w ||'.',1,4500);

			elsif (qt_dias_w > 1) then
				ds_conteudo_w := substr(ds_mensagem_w ||
						' Faltam '|| qt_dias_w || ' dias para a "' || ds_data_calendario_w ||
						'" da câmara ' || ds_camara_w ||' '|| ds_camara_mens_w || ds_mes_w ||'.',1,4500);
			else
				ds_conteudo_w := substr(ds_mensagem_w ||
						' Falta '|| qt_dias_w || ' dia para a "' || ds_data_calendario_w ||
						'" da câmara ' || ds_camara_w ||' '|| ds_camara_mens_w || ds_mes_w ||'.',1,4500);
			end if;

			/* Cursor dos destinatarios das regras */

			open C03;
			loop
			fetch C03 into
				nr_seq_camara_dest_w,
				cd_perfil_w,
				nm_usuario_dest_w,
				ie_email_w,
				ie_comunic_interna_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				/* Gera email */

				if (ie_email_w = 'S') then
					select	max(ds_email)
					into STRICT	ds_email_origem_w
					from	usuario
					where	nm_usuario = nm_usuario_p;

					select	max(ds_email)
					into STRICT	ds_email_destino_w
					from	usuario
					where	nm_usuario = nm_usuario_dest_w;

					if (ds_email_origem_w IS NOT NULL AND ds_email_origem_w::text <> '') and (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') then
						CALL enviar_email(ds_titulo_w,ds_conteudo_w,ds_email_origem_w,ds_email_destino_w,nm_usuario_p,'M');
					end if;
				end if;

				/* Gera comunicação interna */

				if (ie_comunic_interna_w = 'S') then
					CALL gerar_comunic_padrao(	clock_timestamp(),ds_titulo_w,ds_conteudo_w,'Tasy','N',nm_usuario_dest_w,'N',null,
								cd_perfil_w,null,null,clock_timestamp(),null,null);
				end if;

				end;
			end loop;
			close C03;

		end if;

		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_verificar_aviso_camara ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
