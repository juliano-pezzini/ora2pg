-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_pac_cont_aft ON atend_paciente_controle CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_pac_cont_aft() RETURNS trigger AS $BODY$
declare
nr_seq_episodio_w	atendimento_paciente.nr_seq_episodio%type;
nr_seq_episodio_ww	atendimento_paciente.nr_seq_episodio%type;
nr_atendimento_ww	atendimento_paciente.nr_atendimento%type;
nr_seq_agrupador_w	intpd_fila_transmissao.nr_seq_agrupador%type;
qt_reg_w		bigint;
ds_separador_w		varchar(10)	:= ish_param_pck.get_separador;

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_agrupador,
	a.ie_evento,
	a.nr_seq_documento
from	intpd_fila_transmissao a
where	a.nr_seq_agrupador	= nr_seq_agrupador_w
and 	nr_seq_agrupador_w is not null
and	a.ie_status		= 'A'
order by nr_sequencia asc;

c01_w	c01%rowtype;

	procedure excluir_fila(
		nr_seq_fila_p	bigint,
		nr_seq_agrupador_p	bigint)	is
BEGIN
  BEGIN
	
	update	intpd_fila_transmissao
	set	nr_seq_dependencia	 = NULL
	where	nr_seq_agrupador	= nr_seq_agrupador_p
	and	nr_seq_dependencia	= nr_seq_fila_p;

	delete	from	intpd_fila_transmissao
	where	nr_sequencia	= nr_seq_fila_p;
	end;

BEGIN


if (OLD.ie_status_atendimento <> NEW.ie_status_atendimento) then
	BEGIN
	select	a.nr_seq_episodio
	into STRICT	nr_seq_episodio_w
	from	atendimento_paciente a
	where	a.nr_atendimento	= NEW.nr_atendimento;
	
	BEGIN
		select	a.nr_agrupador
		into STRICT	nr_seq_agrupador_w
		from	ish_agrupador a,
			episodio_paciente b
		where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	b.nr_sequencia		= nr_seq_episodio_w;
	exception
	when others then
		nr_seq_agrupador_w := null;
	end;
	
	open C01;
	loop
	fetch C01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
		nr_seq_episodio_ww	:= ish_utils_pck.obter_dados_fila(c01_w.nr_seq_documento, c01_w.ie_evento, 'E');
		nr_atendimento_ww	:= ish_utils_pck.obter_dados_fila(c01_w.nr_seq_documento, c01_w.ie_evento, 'A');
		
		if	(nr_atendimento_ww is not null AND NEW.nr_atendimento = nr_atendimento_ww) or
			(nr_atendimento_ww is null AND nr_seq_episodio_w = nr_seq_episodio_ww) then
			if (NEW.ie_status_atendimento = 'T')	then
				BEGIN			
				update	intpd_fila_transmissao
				set	ie_status	= 'P'
				where	nr_sequencia	= c01_w.nr_sequencia;
				end;
			elsif (NEW.ie_status_atendimento = 'C') then
				BEGIN
				excluir_fila(c01_w.nr_sequencia, c01_w.nr_seq_agrupador);
				end;
			end if;
		end if;		
		end;
	end loop;
	close C01;
	end;	
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_pac_cont_aft() FROM PUBLIC;

CREATE TRIGGER atend_pac_cont_aft
	AFTER UPDATE ON atend_paciente_controle FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_pac_cont_aft();

