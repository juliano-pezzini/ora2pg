-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_cancelar_recorrencia (nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, ie_opcao_p bigint, cd_motivo_p text, ds_motivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_agenda_w		bigint;
dt_agenda_w		timestamp;
ie_tipo_agendamento_w	varchar(1);
nr_seq_agenda_cons_w	agenda_integrada_item.nr_seq_agenda_cons%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	agenda_quimio a,
		agenda_integrada_item b
	where	a.nr_seq_ageint_item = b.nr_sequencia
	and	b.nr_seq_agenda_int = nr_seq_ageint_p
	and	a.ie_status_agenda <> 'C'
	and	a.dt_agenda > dt_agenda_w
	
union all

	SELECT	a.nr_sequencia
	from	agenda_quimio a,
		agenda_integrada_item b
	where	a.nr_seq_ageint_item = b.nr_sequencia
	and	b.nr_seq_agenda_int = nr_seq_ageint_p
	and	a.ie_status_agenda <> 'C'
	and	b.nr_sequencia = nr_seq_ageint_item_p
	order by 1;
	
C02 CURSOR FOR
	SELECT	b.nr_sequencia
	FROM	agenda_consulta a,
		agenda_integrada_item b
	WHERE	a.nr_sequencia = b.nr_seq_agenda_cons
	AND	b.nr_seq_agenda_int = nr_seq_ageint_p
	AND	a.ie_status_agenda <> 'C'
	AND	a.dt_agenda > dt_agenda_w
	
UNION ALL

	SELECT	b.nr_sequencia
	FROM	agenda_consulta a,
		agenda_integrada_item b
	WHERE	a.nr_sequencia = b.nr_seq_agenda_cons
	AND	b.nr_seq_agenda_int = nr_seq_ageint_p
	AND	a.ie_status_agenda <> 'C'
	AND	b.nr_sequencia = nr_seq_ageint_item_p
	ORDER BY 1;
				

BEGIN
begin
	select 	ie_tipo_agendamento
	into STRICT	ie_tipo_agendamento_w
	from 	agenda_integrada_item 
	where 	nr_seq_agenda_int = nr_seq_ageint_p
	and 	nr_sequencia = nr_seq_ageint_item_p;
	exception
		when others then
		ie_tipo_agendamento_w := null;
  end;

   begin
select 	nr_seq_agenda_cons
into STRICT	nr_seq_agenda_cons_w
from 	agenda_integrada_item 
where 	nr_seq_agenda_int = nr_seq_ageint_p
and 	nr_sequencia = nr_seq_ageint_item_p;
	exception
		when others then
		nr_seq_agenda_cons_w := null;
  end;

/* opcao
    0 - Somente data selecionada
    1 - Todas as datas de recorrencia
*/
if (ie_tipo_agendamento_w IS NOT NULL AND ie_tipo_agendamento_w::text <> '' AND (ie_tipo_agendamento_w = 'S' or ie_tipo_agendamento_w = 'C')) then
	if (ie_opcao_p = 0) then
				
		CALL ageint_cancelar_item(nr_seq_ageint_p,
					nr_seq_ageint_item_p,
					ds_motivo_p,
					cd_motivo_p,
					nm_usuario_p,
					cd_estabelecimento_p
					);		
	elsif (ie_opcao_p = 1) then
		select 	max(dt_agenda)
		into STRICT	dt_agenda_w
		from agenda_consulta
		where nr_sequencia = nr_seq_agenda_cons_w;
		
		open C02;
		loop
		fetch C02 into	
			nr_seq_agenda_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			CALL ageint_cancelar_item(nr_seq_ageint_p,
					nr_seq_agenda_w,
					ds_motivo_p,
					cd_motivo_p,
					nm_usuario_p,
					cd_estabelecimento_p
					);			
			end;
		end loop;
		close C02;
	end if;
else
	if (ie_opcao_p = 0) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_agenda_w
		from	agenda_quimio
		where	nr_seq_ageint_item = nr_seq_ageint_item_p;
		
		CALL qt_alterar_status_agenda(nr_seq_agenda_w,
					'C',
					nm_usuario_p,
					'N',
					cd_motivo_p,
					ds_motivo_p,
					cd_estabelecimento_p,
					'');
		
	elsif (ie_opcao_p = 1) then
		select	max(dt_agenda)
		into STRICT	dt_agenda_w
		from	agenda_quimio
		where	nr_seq_ageint_item = nr_seq_ageint_item_p;
			
		open C01;
		loop
		fetch C01 into	
			nr_seq_agenda_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			CALL qt_alterar_status_agenda(nr_seq_agenda_w,
					'C',
					nm_usuario_p,
					'N',
					cd_motivo_p,
					ds_motivo_p,
					cd_estabelecimento_p,
					'');
			end;
		end loop;
		close C01;
	end if;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_cancelar_recorrencia (nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, ie_opcao_p bigint, cd_motivo_p text, ds_motivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
