-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_controle_sessao ( nr_seq_ageint_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		agenda_integrada_item.nr_sequencia%type;
nr_seq_agenda_int_w	agenda_integrada_item.nr_seq_agenda_int%type;
ie_tipo_agendamento_w	agenda_integrada_item.ie_tipo_agendamento%type;
ie_tipo_item_w		agenda_integrada_item.ie_tipo_item%type;
nr_seq_item_princ_w	agenda_integrada_item.nr_seq_item_princ%type;
dt_prevista_item_w	agenda_integrada_item.dt_prevista_item%type;
nr_seq_agenda_cons_w	agenda_integrada_item.nr_seq_agenda_cons%type;
dt_agenda_w		agenda_consulta.dt_agenda%type;
nr_controle_w		agenda_consulta.nr_controle_secao%type;
qt_total_secoes_w	agenda_consulta.qt_total_secao%type;
nr_secao_w		agenda_consulta.nr_secao%type;
			
C01 CURSOR FOR
	SELECT	nr_seq_agenda_cons
	from	agenda_integrada_item
	where ((nr_seq_item_princ IS NOT NULL AND nr_seq_item_princ::text <> '') or ie_tipo_item = 'P')
	and	ie_tipo_agendamento	= 'S'
	and	nr_seq_agenda_int	= nr_seq_ageint_p
	order by DT_PREVISTA_ITEM,
		nr_seq_agenda_cons;
		
C02 CURSOR FOR
	SELECT	nr_seq_agenda_cons
	from	agenda_integrada_item
	where ((nr_seq_item_princ IS NOT NULL AND nr_seq_item_princ::text <> '') or ie_tipo_item = 'P')
	and	ie_tipo_agendamento	= 'C'
	and	nr_seq_agenda_int	= nr_seq_ageint_p
	order by DT_PREVISTA_ITEM,
		nr_seq_agenda_cons;
			

BEGIN
if (coalesce(nr_seq_ageint_p,0) > 0) then

	select	max(a.nr_seq_agenda_cons),
		max(b.dt_agenda)
	into STRICT	nr_sequencia_w,
		dt_agenda_w
	from	agenda_integrada_item a,
		agenda_consulta b
	where	a.nr_seq_agenda_int	= nr_seq_ageint_p
	and	a.nr_seq_agenda_cons	= b.nr_sequencia
	and	a.ie_tipo_item		= 'P'
	and a.ie_tipo_agendamento	= 'S';
	
	nr_controle_w := insere_agenda_cons_cont_secao(dt_agenda_w, nr_sequencia_w, nm_usuario_p, nr_controle_w);
	
	select	count(1)
	into STRICT	qt_total_secoes_w
	from	agenda_integrada_item
	where ((nr_seq_item_princ IS NOT NULL AND nr_seq_item_princ::text <> '') or ie_tipo_item = 'P')
	and	ie_tipo_agendamento	= 'S'
	and	nr_seq_agenda_int	= nr_seq_ageint_p;
	
	nr_secao_w := 0;
	
	open C01;
	loop
	fetch C01 into	
		nr_seq_agenda_cons_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_secao_w	:= nr_secao_w + 1;
		
		update	agenda_consulta
		set	nr_controle_secao	= nr_controle_w,
			nr_secao		= nr_secao_w,
			qt_total_secao		= qt_total_secoes_w
		where	nr_sequencia		= nr_seq_agenda_cons_w;
		end;
	end loop;
	close C01;
	
	
	select	max(a.nr_seq_agenda_cons),
		max(b.dt_agenda)
	into STRICT	nr_sequencia_w,
		dt_agenda_w
	from	agenda_integrada_item a,
		agenda_consulta b
	where	a.nr_seq_agenda_int	= nr_seq_ageint_p
	and	a.nr_seq_agenda_cons	= b.nr_sequencia
	and	a.ie_tipo_item		= 'P'
	and a.ie_tipo_agendamento	= 'C';
	
	nr_controle_w := insere_agenda_cons_cont_secao(dt_agenda_w, nr_sequencia_w, nm_usuario_p, nr_controle_w);
	
	select	count(1)
	into STRICT	qt_total_secoes_w
	from	agenda_integrada_item
	where ((nr_seq_item_princ IS NOT NULL AND nr_seq_item_princ::text <> '') or ie_tipo_item = 'P')
	and	ie_tipo_agendamento	= 'C'
	and	nr_seq_agenda_int	= nr_seq_ageint_p;
	
	nr_secao_w := 0;
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_agenda_cons_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		nr_secao_w	:= nr_secao_w + 1;
		
		update	agenda_consulta
		set	nr_controle_secao	= nr_controle_w,
			nr_secao		= nr_secao_w,
			qt_total_secao		= qt_total_secoes_w
		where	nr_sequencia		= nr_seq_agenda_cons_w;
		end;
	end loop;
	close C02;	
	
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_controle_sessao ( nr_seq_ageint_p bigint, nm_usuario_p text) FROM PUBLIC;

