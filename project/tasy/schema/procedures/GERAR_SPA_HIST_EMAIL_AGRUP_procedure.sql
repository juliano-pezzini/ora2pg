-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (ie_tipo_envio			spa_hist_email.ie_tipo_envio%type,
		ds_email			spa_hist_email_destino.ds_email%type,
		ds_mensagem_padrao		spa_hist_email_destino.ds_mensagem_padrao%type,
		ds_assunto			spa_hist_email.ds_assunto%type,
		nr_seq_hist_email_dest		spa_hist_email_destino.nr_sequencia%type,
		nr_seq_hist_email		spa_hist_email.nr_sequencia%type,
		nr_seq_spa			spa.nr_sequencia%type,
		nm_usuario_aprovador		usuario.nm_usuario%type,
		nr_seq_regra_envio		spa_hist_email.nr_seq_regra_envio%type);
CREATE TYPE camposDist AS (ie_tipo_envio			spa_hist_email.ie_tipo_envio%type,
		ds_email			spa_hist_email_destino.ds_email%type,
		ds_assunto			spa_hist_email.ds_assunto%type,
		nm_usuario_aprovador		usuario.nm_usuario%type,
		nr_seq_regra_envio		spa_hist_email.nr_seq_regra_envio%type,
		ds_mensagem_envio		spa_hist_email_destino.ds_mensagem_padrao%type,
		qt_total_pend_agrup		bigint);


CREATE OR REPLACE PROCEDURE gerar_spa_hist_email_agrup (dt_geracao_p timestamp, nm_usuario_p text, ie_tipo_mensagem_p text default null) AS $body$
DECLARE


type Vetor is
	table of campos index by integer;

type VetorDist is
	table of camposDist index by integer;

j				integer := 1;
x				integer := 1;
a				integer := 1;
b				integer := 1;
i				integer := 1;
q				integer := 1;
m				integer := 1;

Vetor_Pendencias_w		Vetor;
Vetor_PendenciasDist_w		VetorDist;



ie_tipo_mensagem_regra_w	spa_regra_agrup_email.ie_tipo_mensagem%type;
ie_tipo_envio_w			spa_hist_email.ie_tipo_envio%type;
ds_email_w			spa_hist_email_destino.ds_email%type;
ds_mensagem_padrao_w		spa_hist_email_destino.ds_mensagem_padrao%type;
ds_assunto_w			spa_hist_email.ds_assunto%type;
nr_seq_hist_email_w		spa_hist_email.nr_sequencia%type;
nr_seq_hist_email_dest_w 	spa_hist_email_destino.nr_sequencia%type;
nr_seq_spa_w			spa.nr_sequencia%type;
nm_usuario_aprov_w		usuario.nm_usuario%type;
ds_email_origem_w		spa_regra_email.ds_email_origem%type;
nr_seq_regra_envio_aux_w	spa_hist_email.nr_seq_regra_envio%type;
ie_enviar_mensagem_w		varchar(1);
ie_divide_mensagem_w		varchar(1);
ds_mensagem_agrupada_w		varchar(32000);
ds_mensagem_unica_w		varchar(32000);
ds_parte_mensagem_w		varchar(32000);
ds_mensagem_envio_w		varchar(32000);
ie_achou_w			varchar(1);
ie_existe_w			varchar(1);
qt_max_envio_w			spa_regra_agrup_email.qt_max_envio%type;
qt_total_pend_agrup_w		bigint;
ie_forma_w			bigint;
ds_email_ant_w			varchar(255);


C01 CURSOR FOR
	SELECT	ie_tipo_mensagem
	from	(SELECT	1 nr_ordem,
			a.ie_tipo_mensagem ie_tipo_mensagem
		from	spa_regra_agrup_email a
		where	to_char(dt_geracao_p,'hh24') = a.qt_hora
		and	a.ie_tipo_mensagem = 'P'
		and 	((coalesce(ie_tipo_mensagem_p::text, '') = '') or (a.ie_tipo_mensagem = ie_tipo_mensagem_p))
		
union

		select	2 nr_ordem,
			a.ie_tipo_mensagem ie_tipo_mensagem
		from	spa_regra_agrup_email a
		where	to_char(dt_geracao_p,'hh24') = a.qt_hora
		and	a.ie_tipo_mensagem = 'A'
		and 	((coalesce(ie_tipo_mensagem_p::text, '') = '') or (a.ie_tipo_mensagem = ie_tipo_mensagem_p))
		
union

		select	3 nr_ordem,
			a.ie_tipo_mensagem ie_tipo_mensagem
		from	spa_regra_agrup_email a
		where	to_char(dt_geracao_p,'hh24') = a.qt_hora
		and 	((coalesce(ie_tipo_mensagem_p::text, '') = '') or (a.ie_tipo_mensagem = ie_tipo_mensagem_p))
		and	a.ie_tipo_mensagem = 'C') alias15
	where	1 = 1
	order by nr_ordem;



C02 CURSOR FOR
	SELECT	1,
		b.ie_tipo_envio,
		a.ds_email,
		a.ds_mensagem_padrao,
		b.ds_assunto,
		a.nr_sequencia,
		b.nr_sequencia,
		b.nr_seq_spa,
		a.nm_usuario_aprovador,
		coalesce(b.nr_seq_regra_envio,0)
	from	spa_hist_email_destino a,
		spa_hist_email b,
		spa c
	where	a.nr_seq_hist_email 	= b.nr_sequencia
	and 	c.nr_sequencia = b.nr_seq_spa
	and	b.ie_tipo_mensagem	= ie_tipo_mensagem_regra_w
	and	b.ie_forma_envio        = 'A'
	and	coalesce(b.dt_estorno_lib_spa::text, '') = ''
	and 	c.ie_status < 4
	--and	a.dt_envio is null
	and	b.ie_tipo_mensagem <> 'P'

union all

	SELECT	2,
		b.ie_tipo_envio,
		a.ds_email,
		a.ds_mensagem_padrao,
		b.ds_assunto,
		a.nr_sequencia,
		b.nr_sequencia,
		b.nr_seq_spa,
		a.nm_usuario_aprovador,
		coalesce(b.nr_seq_regra_envio,0)
	from	spa_hist_email_destino a,
		spa_hist_email b,
		spa c,
		spa_aprovacao x
	where	a.nr_seq_hist_email 	= b.nr_sequencia
	and 	c.nr_sequencia = b.nr_seq_spa
	and	b.ie_tipo_mensagem	= ie_tipo_mensagem_regra_w
	and	b.ie_forma_envio        = 'A'
	and 	x.nr_seq_spa = b.nr_seq_spa
	and	coalesce(b.dt_estorno_lib_spa::text, '') = ''
	and     coalesce(x.cd_cargo_aprov::text, '') = ''
	and     (x.nm_usuario_aprov IS NOT NULL AND x.nm_usuario_aprov::text <> '')
	and 	c.ie_status < 4
	and	b.ie_tipo_mensagem = 'P'
	and  	a.nm_usuario_aprovador = x.nm_usuario_aprov
	and	x.nr_sequencia = (select max(k.nr_sequencia)
				  from	 spa_aprovacao k
				  where	k.nr_seq_spa = x.nr_seq_spa
				  and	(k.dt_lib_aprov IS NOT NULL AND k.dt_lib_aprov::text <> '')
				  and	coalesce(k.dt_aprovacao::text, '') = '')

union all

	select	3,
		b.ie_tipo_envio,
		a.ds_email,
		a.ds_mensagem_padrao,
		b.ds_assunto,
		a.nr_sequencia,
		b.nr_sequencia,
		b.nr_seq_spa,
		a.nm_usuario_aprovador,
		coalesce(b.nr_seq_regra_envio,0)
	from    spa_hist_email_destino a,
		spa_hist_email b,
		usuario u,
		spa_aprovacao x
	where   a.nr_seq_hist_email     = b.nr_sequencia
	and	b.ie_tipo_mensagem	= ie_tipo_mensagem_regra_w
	and     b.ie_tipo_mensagem      = 'P'
	and     b.ie_forma_envio        = 'A'
	and     coalesce(b.dt_estorno_lib_spa::text, '') = ''
	and     (x.cd_cargo_aprov IS NOT NULL AND x.cd_cargo_aprov::text <> '')
	and     coalesce(x.nm_usuario_aprov::text, '') = ''
	and     x.nr_seq_spa     = b.nr_seq_spa
	and     a.cd_cargo       = x.cd_cargo_aprov
	and     a.nm_usuario_aprovador =  u.nm_usuario
	and     x.nr_sequencia =       (select max(k.nr_sequencia)
					from    spa_aprovacao k
					where   k.nr_seq_spa = x.nr_seq_spa
					and     (k.dt_lib_aprov IS NOT NULL AND k.dt_lib_aprov::text <> '')
					and     coalesce(k.dt_aprovacao::text, '') = '')
	order by ds_email, nr_seq_spa, 1;



BEGIN

Vetor_Pendencias_w.delete;
Vetor_PendenciasDist_w.delete;


open C01;
loop
fetch C01 into
	ie_tipo_mensagem_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(qt_max_envio),0)
	into STRICT	qt_max_envio_w
	from	spa_regra_agrup_email a
	where	a.ie_tipo_mensagem = ie_tipo_mensagem_regra_w;

	qt_total_pend_agrup_w	:= 0;
	ds_mensagem_unica_w	:= '';
	ds_parte_mensagem_w	:= '';
	ie_divide_mensagem_w	:= 'N';
	ie_enviar_mensagem_w	:= 'N';
	ds_mensagem_agrupada_w	:= '';
	ds_email_ant_w		:= '';

	open C02;
	loop
	fetch C02 into
		ie_forma_w,
		ie_tipo_envio_w,
		ds_email_w,
		ds_mensagem_padrao_w,
		ds_assunto_w,
		nr_seq_hist_email_dest_w,
		nr_seq_hist_email_w,
		nr_seq_spa_w,
		nm_usuario_aprov_w,
		nr_seq_regra_envio_aux_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		/*if	(ds_email_ant_w <> ds_email_w) then
			qt_total_pend_agrup_w:= 0;
		end if;

		if	((ie_forma_w = 3) and (ds_email_ant_w = ds_email_w)) or (ie_forma_w <> 3) then
			qt_total_pend_agrup_w:= qt_total_pend_agrup_w + 1;
		end if;*/
		if (ds_email_ant_w <> ds_email_w) then
			qt_total_pend_agrup_w:= 0;
		end if;
		qt_total_pend_agrup_w:= qt_total_pend_agrup_w + 1;

		i:= coalesce(Vetor_Pendencias_w.Count,0) + 1;
		Vetor_Pendencias_w[i].ie_tipo_envio  	   	:= ie_tipo_envio_w;
		Vetor_Pendencias_w[i].ds_email  	   	:= ds_email_w;
		Vetor_Pendencias_w[i].ds_mensagem_padrao  	:= ds_mensagem_padrao_w;
		Vetor_Pendencias_w[i].ds_assunto 	   	:= ds_assunto_w;
		Vetor_Pendencias_w[i].nr_seq_hist_email_dest 	:= nr_seq_hist_email_dest_w;
		Vetor_Pendencias_w[i].nr_seq_hist_email 	:= nr_seq_hist_email_w;
		Vetor_Pendencias_w[i].nr_seq_spa 		:= nr_seq_spa_w;
		Vetor_Pendencias_w[i].nm_usuario_aprovador 	:= nm_usuario_aprov_w;
		Vetor_Pendencias_w[i].nr_seq_regra_envio 	:= nr_seq_regra_envio_aux_w;

		ie_achou_w:= 'N';
		for x in 1..Vetor_PendenciasDist_w.count loop
			if (Vetor_PendenciasDist_w[x].ie_tipo_envio = ie_tipo_envio_w) and (Vetor_PendenciasDist_w[x].ds_email = ds_email_w) and (Vetor_PendenciasDist_w[x].ds_assunto = ds_assunto_w) and (Vetor_PendenciasDist_w[x].nm_usuario_aprovador = nm_usuario_aprov_w) and (Vetor_PendenciasDist_w[x].nr_seq_regra_envio = nr_seq_regra_envio_aux_w) then
				ie_achou_w := 'S';
				q:= x;
			end if;
		end loop;

		ie_enviar_mensagem_w	:= 'S';

		if (position('%' in ds_mensagem_padrao_w) > 0) and (ie_divide_mensagem_w = 'N') then
			ie_divide_mensagem_w := 'S';
		end if;

		if (ie_divide_mensagem_w = 'S') then

			/*Pega o pedaço que está entre % */

			ds_parte_mensagem_w	:= substr(substr(ds_mensagem_padrao_w,position('%' in ds_mensagem_padrao_w)+1,32000),1,position('%' in substr(ds_mensagem_padrao_w,position('%' in ds_mensagem_padrao_w)+1,32000))-1);

			ie_existe_w:= 'N';
			if (ds_email_ant_w <> ds_email_w) then
				ds_mensagem_agrupada_w:= '';
			end if;

			/*Vai concatenando os pedaços das mensagens que estão entre %*/

			ds_mensagem_agrupada_w	:= ds_mensagem_agrupada_w || ds_parte_mensagem_w || chr(13) || chr(10) || chr(13) || chr(10);

			if (coalesce(ds_mensagem_unica_w::text, '') = '') or (ds_email_ant_w <> ds_email_w) then
				/*Essa é a mensagem que está fora dos %*/

				ds_mensagem_unica_w	:= 	substr(replace(replace(ds_mensagem_padrao_w, ds_parte_mensagem_w, '#@#@'),'%',''),1,32000);
			end if;
		else
			ds_mensagem_envio_w := ds_mensagem_envio_w || ds_mensagem_padrao_w || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10);
		end if;

		if (ie_divide_mensagem_w = 'S') then
			ds_mensagem_envio_w	:= substr(replace(ds_mensagem_unica_w,'#@#@',ds_mensagem_agrupada_w),1,32000);
		end if;

		if (ie_achou_w = 'N') then
			j:= coalesce(Vetor_PendenciasDist_w.Count,0) + 1;
			Vetor_PendenciasDist_w[j].ie_tipo_envio  	:= ie_tipo_envio_w;
			Vetor_PendenciasDist_w[j].ds_email  	   	:= ds_email_w;
			Vetor_PendenciasDist_w[j].ds_assunto 	   	:= ds_assunto_w;
			Vetor_PendenciasDist_w[j].nm_usuario_aprovador 	:= nm_usuario_aprov_w;
			Vetor_PendenciasDist_w[j].nr_seq_regra_envio 	:= nr_seq_regra_envio_aux_w;
			Vetor_PendenciasDist_w[j].ds_mensagem_envio 	:= ds_mensagem_envio_w;
			Vetor_PendenciasDist_w[j].qt_total_pend_agrup	:= qt_total_pend_agrup_w;
		else
			Vetor_PendenciasDist_w[q].ds_mensagem_envio := ds_mensagem_envio_w;
			Vetor_PendenciasDist_w[q].qt_total_pend_agrup := qt_total_pend_agrup_w;
		end if;

		ds_email_ant_w	:= ds_email_w;

		end;
	end loop;
	close C02;


	for a in 1..Vetor_PendenciasDist_w.count loop
		begin

		if	(((ie_tipo_mensagem_p IS NOT NULL AND ie_tipo_mensagem_p::text <> '') and (qt_max_envio_w > 0) and (Vetor_PendenciasDist_w[a].qt_total_pend_agrup >= qt_max_envio_w)) or (coalesce(ie_tipo_mensagem_p::text, '') = '')) then

			if (Vetor_PendenciasDist_w[a].ie_tipo_envio = 'E') and (position('@' in Vetor_PendenciasDist_w[a].ds_email) > 0) then

				select	max(ds_email_origem)
				into STRICT	ds_email_origem_w
				from 	spa_regra_email
				where 	nr_sequencia = Vetor_PendenciasDist_w[a].nr_seq_regra_envio;

				if (coalesce(ds_email_origem_w::text, '') = '') then
					select	max(ds_email)
					into STRICT	ds_email_origem_w
					from	usuario
					where	nm_usuario	= nm_usuario_p;
				end if;

				CALL enviar_email(Vetor_PendenciasDist_w[a].ds_assunto,coalesce(Vetor_PendenciasDist_w[a].ds_mensagem_envio, ds_mensagem_padrao_w) ,ds_email_origem_w,Vetor_PendenciasDist_w[a].ds_email,null,'M');

			elsif (Vetor_PendenciasDist_w[a].ie_tipo_envio = 'C') then

				CALL Gerar_Comunic_Padrao(clock_timestamp(),
						Vetor_PendenciasDist_w[a].ds_assunto,
						coalesce(Vetor_PendenciasDist_w[a].ds_mensagem_envio, ds_mensagem_padrao_w),
						nm_usuario_p,
						'N',
						Vetor_PendenciasDist_w[a].nm_usuario_aprovador,
						'N',
						null,--classif
						null,
						wheb_usuario_pck.get_cd_Estabelecimento,
						null,
						clock_timestamp(),
						null,
						null);

			end if;

			for b in 1..Vetor_Pendencias_w.count loop
				begin
				if (Vetor_PendenciasDist_w[a].ie_tipo_envio 	= Vetor_Pendencias_w[b].ie_tipo_envio) and (Vetor_PendenciasDist_w[a].ds_email 		= Vetor_Pendencias_w[b].ds_email) and (Vetor_PendenciasDist_w[a].ds_assunto 		= Vetor_Pendencias_w[b].ds_assunto) and (Vetor_PendenciasDist_w[a].nm_usuario_aprovador = Vetor_Pendencias_w[b].nm_usuario_aprovador) and (Vetor_PendenciasDist_w[a].nr_seq_regra_envio 	= Vetor_Pendencias_w[b].nr_seq_regra_envio) then

					update	spa_hist_email_destino
					set	dt_atualizacao 	= clock_timestamp(),
						nm_usuario     	= nm_usuario_p,
						dt_envio       	= clock_timestamp()
					where	nr_sequencia   	= Vetor_Pendencias_w[b].nr_seq_hist_email_dest;
				end if;
				end;
			end loop;

		end if;

		end;
	end loop;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_spa_hist_email_agrup (dt_geracao_p timestamp, nm_usuario_p text, ie_tipo_mensagem_p text default null) FROM PUBLIC;
