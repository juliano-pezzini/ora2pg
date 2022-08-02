-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_via_acesso_conta ( nr_seq_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_guia_referencia_w		varchar(20);
nr_seq_segurado_w		bigint;
ie_tipo_guia_w			varchar(15);
cd_medico_executor_w		varchar(20);
nr_seq_regra_w			bigint;
ie_via_acesso_w			varchar(255);
qt_proc_regra_w			double precision;
qt_proc_final_w			bigint;
cd_proc_regra_w			bigint;
ie_origem_proced_regra_w	bigint;
qt_pos_proc_w			bigint;
nr_seq_conta_proc_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_proc_conta_w			double precision;
tx_item_w			double precision;
ie_nao_pego_regra_w		varchar(10)	:= 'N';
cd_estabelecimento_w		bigint;
ie_via_acesso_regra_w		varchar(10);
dt_procedimento_w		varchar(20);
dt_procedimento_ww		varchar(20);
dt_inicio_proc_w		varchar(15);
dt_inicio_proc_ww		varchar(255);
dt_fim_proc_w			varchar(15);
cd_procedimento_ww		bigint;
ie_origem_proced_ww		bigint;
nr_seq_regra_ww			varchar(255);
nr_seq_proc_ref_w		bigint;
ie_simultaneo_w			varchar(255);
ie_origem_conta_w		varchar(1);
ie_via_acesso_imp_w		varchar(1);
ie_via_acesso_ww		varchar(1);
ie_via_acesso_inf_w		varchar(1)	:= 'S';
nr_seq_regra_proc_via_w		bigint;
ie_via_acesso_ant_w		varchar(1);
nr_seq_regra_via_acesso_w	bigint;
qt_item_ref_w			bigint;
ie_considerar_horario_w		varchar(1);
qt_horario_w			smallint;
ie_tipo_qt_horario_w		varchar(5);
qt_minuto_w			bigint;
ie_via_acesso_manual_w		pls_conta_proc.ie_via_acesso_manual%type;
ie_tipo_intercambio_w		pls_tipo_via_acesso.ie_tipo_intercambio%type;
tx_item_variavel_w		pls_proc_via_acesso.tx_item_variavel%type;

C00 CURSOR FOR
	SELECT	a.ie_via_acesso,
		coalesce(a.qt_procedimento,0),
		coalesce(a.qt_proc_final,9999999),
		a.cd_procedimento,
		a.ie_origem_proced,
		nr_sequencia,
		a.ie_considerar_horario,
		coalesce(a.qt_horario,0),
		a.ie_tipo_qt_horario,
		(	SELECT	max(x.ie_tipo_intercambio)
			from	pls_tipo_via_acesso	x
			where	x.nr_sequencia		= a.nr_seq_regra) ie_tipo_intercambio,
		a.tx_item_variavel
	from	pls_proc_via_acesso a
	where	a.nr_seq_regra = nr_seq_regra_w
	order by coalesce(a.qt_procedimento,0),
		 coalesce(a.cd_procedimento,0);

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		coalesce(a.qt_procedimento_imp,0),
		to_char(dt_procedimento,'dd/mm/yyyy') dt_proc,
		to_char(dt_inicio_proc,'hh24:mi:ss') dt_inicio,
		to_char(dt_fim_proc,'hh24:mi:ss'),
		a.nr_seq_proc_ref,
		a.ie_via_acesso_imp,
		a.ie_via_acesso,
		a.nr_seq_regra_via_acesso,
		( SELECT	count(1)
		  from		pls_conta_proc c
		  where		c.nr_seq_proc_ref = a.nr_sequencia ) qt_item_ref,
		a.ie_via_acesso_manual
	from	pls_conta_proc	a,
		pls_conta	b
	where	b.nr_sequencia		= a.nr_seq_conta
	and	coalesce(coalesce(b.cd_guia_referencia,b.cd_guia),'0')		= cd_guia_referencia_w
	and	b.nr_seq_segurado	= nr_seq_segurado_w
	and	coalesce(a.ie_glosa,'N')	<> 'S'
	--and 	((ie_via_acesso is null) or (ie_via_acesso <> ie_via_acesso_ant_w))
	and	(a.qt_procedimento_imp IS NOT NULL AND a.qt_procedimento_imp::text <> '')
	and	coalesce(ie_via_obrigatoria,'N') 	= 'S'
	order by 
		dt_proc,
		dt_inicio,
		coalesce(a.nr_seq_proc_ref,0),
		qt_item_ref desc,
		b.nr_sequencia,
		a.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.dt_fim_proc;


BEGIN

select	coalesce(coalesce(cd_guia_referencia,cd_guia),'0'),
	nr_seq_segurado,
	ie_tipo_guia,
	cd_medico_executor,
	ie_origem_conta,
	cd_estabelecimento
into STRICT	cd_guia_referencia_w,
	nr_seq_segurado_w,
	ie_tipo_guia_w,
	cd_medico_executor_w,
	ie_origem_conta_w,
	cd_estabelecimento_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

update	pls_conta_proc a
set	a.ie_via_acesso	 = NULL,
	a.tx_item			= 100,
	a.nr_seq_regra_via_acesso	 = NULL
where	(a.nr_seq_regra_via_acesso IS NOT NULL AND a.nr_seq_regra_via_acesso::text <> '')
and	exists (SELECT	1
		from	pls_conta x
		where 	a.nr_seq_conta = x.nr_sequencia
		and	((x.cd_guia = cd_guia_referencia_w) or (x.cd_guia_referencia = cd_guia_referencia_w))
		and	x.nr_seq_segurado = nr_seq_segurado_w)
and	exists ( select 1
		  from	pls_conta_proc y
		  where	y.nr_seq_conta = nr_seq_conta_p
		  and	trunc(y.dt_procedimento,'dd')= trunc(a.dt_procedimento,'dd')
		  and	coalesce(y.ie_status,'U')	<> 'D'
		  and	coalesce(y.ie_via_obrigatoria,'N') = 'S');


/* Rotina responsável por verificar se todos os procedimentos da conta possuem uma regra de via de acesso válida. Caso 1 procedimento não possuir, não entra na regra de via de acesso. */


/* Esta rotina retorna uma lista com todas as regra utilizadas na conta. */

nr_seq_regra_ww := pls_obter_regra_via_acesso(nr_seq_conta_p, nm_usuario_p, nr_seq_regra_ww);

begin
select	coalesce(ie_via_acesso_regra,'N')
into STRICT	ie_via_acesso_regra_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_w;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(243964);
end;

if (coalesce(nr_seq_regra_ww,'0') <> '0') then
	/* Rotina responsável por desmembrar os procedimentos da conta, ou seja, caso um procedimento possua qt. apresentada = 5, esta rotina irá criar 5 registros com quantidade apresentada 1 */

	CALL pls_desmembrar_proc_via_acesso(nr_seq_conta_p,nm_usuario_p,nr_seq_regra_ww);

	WHILE(length(nr_seq_regra_ww) > 0) LOOP
		BEGIN
		if (position(',' in nr_seq_regra_ww) > 0) then
			nr_seq_regra_w	:= (substr(nr_seq_regra_ww,1,position(',' in nr_seq_regra_ww) -1))::numeric;
			nr_seq_regra_ww	:= substr(nr_seq_regra_ww,position(',' in nr_seq_regra_ww) + 1,length(nr_seq_regra_ww));
		else
			nr_seq_regra_w	:= (nr_seq_regra_ww)::numeric;
			nr_seq_regra_ww	:= null;
		end if;
		
		open C00;
		loop
		fetch C00 into	
			ie_via_acesso_w,
			qt_proc_regra_w,
			qt_proc_final_w,
			cd_proc_regra_w,
			ie_origem_proced_regra_w,
			nr_seq_regra_proc_via_w,
			ie_considerar_horario_w,
			qt_horario_w,
			ie_tipo_qt_horario_w,
			ie_tipo_intercambio_w,
			tx_item_variavel_w;
		EXIT WHEN NOT FOUND; /* apply on C00 */
			begin
			qt_pos_proc_w	:= 0;
			
			if (ie_tipo_qt_horario_w = 'H') then
				qt_minuto_w := coalesce(qt_horario_w,0) * 60;
			elsif (ie_tipo_qt_horario_w = 'M') then
				qt_minuto_w := coalesce(qt_horario_w,0);
			end if;
			
			open C01;
			loop
			fetch C01 into	
				nr_seq_conta_proc_w,
				cd_procedimento_w,
				ie_origem_proced_w,
				qt_proc_conta_w,
				dt_procedimento_w,
				dt_inicio_proc_w,
				dt_fim_proc_w,
				nr_seq_proc_ref_w,
				ie_via_acesso_imp_w,
				ie_via_acesso_ww,
				nr_seq_regra_via_acesso_w,
				qt_item_ref_w,
				ie_via_acesso_manual_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				ie_via_acesso_inf_w := 'S';
				if (coalesce(ie_origem_conta_w,'D') = 'E') and (coalesce(ie_via_acesso_regra_w,'N') = 'S') then
					if (coalesce(ie_via_acesso_ww,'X') = coalesce(ie_via_acesso_imp_w,'X')) and (not ie_via_acesso_manual_w	= 'S')then
						ie_via_acesso_inf_w	:= 'N';
					end if;
				end if;

				if ( ie_via_acesso_inf_w = 'N') or ( coalesce(ie_via_acesso_ww,'X') = 'X') or ( coalesce(ie_via_acesso_regra_w,'N') = 'N' ) or
					(nr_seq_regra_via_acesso_w IS NOT NULL AND nr_seq_regra_via_acesso_w::text <> '' AND ie_via_acesso_ww = 'U' )then
					begin
					ie_simultaneo_w	:= pls_obter_se_conta_simul(dt_procedimento_w, to_date(dt_inicio_proc_w,'hh24:mi:ss'), to_date(dt_fim_proc_w,'hh24:mi:ss'), nr_seq_conta_p, nr_seq_regra_w);
		
					if (ie_simultaneo_w = 'S') then
						if (cd_procedimento_w	= cd_proc_regra_w) and (ie_origem_proced_w	= ie_origem_proced_regra_w) then
					
							/* Criada a estrutura desta forma para os casos onde a regra for de 2 a 99 por exemplo. Sendo assim, o sistema apenas irá alterar a via de acesso a partir do 2 procedimento. */

							if (coalesce(dt_inicio_proc_ww::text, '') = '') then
								dt_inicio_proc_ww	:= dt_inicio_proc_w;
							end if;
							
							if (coalesce(dt_procedimento_ww::text, '') = '') then
								dt_procedimento_ww	:= dt_procedimento_w;
							end if;
							
							if (coalesce(cd_procedimento_ww::text, '') = '') then
								cd_procedimento_ww	:= cd_procedimento_w;
							end if;
							
							if (coalesce(ie_origem_proced_ww::text, '') = '') then
								ie_origem_proced_ww	:= ie_origem_proced_w;
							end if;
							if (coalesce(cd_procedimento_w,0) = coalesce(cd_procedimento_ww,0)) and (coalesce(ie_origem_proced_w,0) = coalesce(ie_origem_proced_ww,0)) and (coalesce(dt_inicio_proc_w,'0') = coalesce(dt_inicio_proc_ww,'0')) and
								(((coalesce(dt_inicio_proc_w,'0')	= coalesce(dt_inicio_proc_ww,'0')) and (coalesce(ie_considerar_horario_w,'S') = 'S')) or
								((pls_obter_minutos_intervalo(to_date(dt_inicio_proc_w,'hh24:mi:ss'),to_date(dt_inicio_proc_ww,'hh24:mi:ss'),qt_minuto_w) = 'S')and (ie_considerar_horario_w = 'N'))) and (coalesce(dt_procedimento_w,to_char('01/01/1900')) = coalesce(dt_procedimento_ww,to_char('01/01/1900'))) then
								if (coalesce(nr_seq_proc_ref_w::text, '') = '') then
									qt_pos_proc_w	:= qt_pos_proc_w + 1;
									
								end if;
							else
							
								qt_pos_proc_w	:= 1;
							end if;

							dt_procedimento_ww	:=  dt_procedimento_w;
							dt_inicio_proc_ww	:=  dt_inicio_proc_w;
							cd_procedimento_ww	:= cd_procedimento_w;
							ie_origem_proced_ww	:= ie_origem_proced_w;

							if (qt_pos_proc_w >= qt_proc_regra_w) and (qt_pos_proc_w <= qt_proc_final_w) then
								
								ie_via_acesso_ant_w := ie_via_acesso_w;
								if (nr_seq_proc_ref_w IS NOT NULL AND nr_seq_proc_ref_w::text <> '') then
									begin
									select	ie_via_acesso
									into STRICT	ie_via_acesso_w
									from	pls_conta_proc
									where	nr_sequencia	= nr_seq_proc_ref_w;
									exception
									when others then
										ie_via_acesso_w	:= ie_via_acesso_w;
									end;
								end if;

								-- se tiver tipo de intercambio e qualquer valor de taxa variante(mesmo zero), prioriza a taxa variante
								if (coalesce(ie_tipo_intercambio_w, 'X') in ('A', 'E', 'N')) and (tx_item_variavel_w IS NOT NULL AND tx_item_variavel_w::text <> '') then
								
									tx_item_w	:= tx_item_variavel_w;
								else
									
									tx_item_w	:= obter_tx_proc_via_acesso(ie_via_acesso_w);
								end if;
							
								
								update	pls_conta_proc
								set	ie_via_acesso		= ie_via_acesso_w,
									tx_item			= tx_item_w,
									nr_seq_regra_via_acesso	= nr_seq_regra_w
								where	nr_sequencia		= nr_seq_conta_proc_w;

							else
								
								
								if (nr_seq_proc_ref_w IS NOT NULL AND nr_seq_proc_ref_w::text <> '') then
									begin
									select	ie_via_acesso
									into STRICT	ie_via_acesso_w
									from	pls_conta_proc
									where	nr_sequencia	= nr_seq_proc_ref_w;
									
									-- se tiver tipo de intercambio e qualquer valor de taxa variante(mesmo zero), prioriza a taxa variante
									if (coalesce(ie_tipo_intercambio_w, 'X') in ('A', 'E', 'N')) and (tx_item_variavel_w IS NOT NULL AND tx_item_variavel_w::text <> '') then
									
										tx_item_w	:= tx_item_variavel_w;
									else
									
										tx_item_w	:= obter_tx_proc_via_acesso(ie_via_acesso_w);
									end if;
									
									update	pls_conta_proc
									set	ie_via_acesso		= ie_via_acesso_w,
										tx_item			= tx_item_w,
										nr_seq_regra_via_acesso	= nr_seq_regra_w
									where	nr_sequencia		= nr_seq_conta_proc_w;
									
									exception
									when others then
										update	pls_conta_proc
										set	ie_via_acesso		= 'U',
											tx_item			= 100,
											nr_seq_regra_via_acesso	= nr_seq_regra_w
										where	nr_sequencia		= nr_seq_conta_proc_w
										and	coalesce(nr_seq_regra_via_acesso::text, '') = '';
									end;
								else
									update	pls_conta_proc
									set	ie_via_acesso		= 'U',
										tx_item			= 100,
										nr_seq_regra_via_acesso	= nr_seq_regra_w
									where	nr_sequencia		= nr_seq_conta_proc_w
									and	coalesce(nr_seq_regra_via_acesso::text, '') = '';
								end if;

							end if;
							
						begin
						select	ie_via_acesso
						into STRICT	ie_via_acesso_w
						from	pls_proc_via_acesso
						where	nr_sequencia = nr_seq_regra_proc_via_w;
						exception
						when others then
							ie_via_acesso_w	:= ie_via_acesso_w;
						end;
						end if;
					end if;
					end;
				end if;
				end;
			end loop;
			close C01;
			end;
		end loop;
		close C00;
	END;
	END LOOP;
	/* Felipe - 09/07/2011 - OS 312371 - Limpar a via de acesso caso não encontre regra WHEB NÃO RECOMENDA! */
	
end if;
--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_via_acesso_conta ( nr_seq_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

