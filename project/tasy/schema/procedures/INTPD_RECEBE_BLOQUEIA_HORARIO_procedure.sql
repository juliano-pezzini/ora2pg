-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_bloqueia_horario ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
agenda_consulta_w			agenda_consulta%rowtype;

ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
ie_sistema_externo_w		varchar(15);
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
nr_seq_regra_w				conversao_meio_externo.nr_seq_regra%type;
ds_erro_w						varchar(4000);
ie_atualizou_w					varchar(1) := 'N';
i									integer;

/*'Efetua a consulta transformando o elemento XML num tipo de tabela'*/

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/SCHEDULING' passing xml_p columns

	nr_sequencia	bigint path 'NR_SEQUENCE',
	nm_usuario		varchar(15) path	'NM_USER');

c01_w	c01%rowtype;


BEGIN
/*'Atualiza o status da fila para Em processamento'*/

update	intpd_fila_transmissao
set		ie_status = 'R'
where	nr_sequencia = nr_sequencia_p;

/*'Realiza o commit para não permite o status de processamento em casa de rollback por existir consistência. Existe tratamento de exceção abaixo para colocar o status de erro em caso de falha'*/

commit;

/*'Início de controle de falha'*/

begin
/*'Busca os dados da regra do registro da fila que está em processamento'*/

	select	coalesce(b.ie_conversao,'I'),
				nr_seq_sistema,
				nr_seq_projeto_xml,
				nr_seq_regra_conv
	into STRICT		ie_conversao_w,
				nr_seq_sistema_w,
				nr_seq_projeto_xml_w,
				nr_seq_regra_w
	from		intpd_fila_transmissao a,
				intpd_eventos_sistema b
	where	a.nr_seq_evento_sistema = b.nr_sequencia
	and		a.nr_sequencia = nr_sequencia_p;

	ie_sistema_externo_w	:=	nr_seq_sistema_w;

	/*'Alimenta as informações iniciais de controle e consistência de cada atributo do XML'*/

	reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
	reg_integracao_w.ie_envio_recebe				:=	'R';
	reg_integracao_w.ie_sistema_externo			:=	ie_sistema_externo_w;
	reg_integracao_w.ie_conversao					:=	ie_conversao_w;
	reg_integracao_w.nr_seq_projeto_xml			:=	nr_seq_projeto_xml_w;
	reg_integracao_w.nr_seq_regra_conversao	:=	nr_seq_regra_w;
	reg_integracao_w.intpd_log_receb.delete;
	reg_integracao_w.qt_reg_log	:=	0;

	open c01;
	loop
	fetch c01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			/*'Alimenta as informações de controle e consistência referente ao Elemento a ser processado no momento. É importante manter dentro do cursor e não fora.'*/

			reg_integracao_w.nm_tabela		:=	'AGENDA_CONSULTA';
			reg_integracao_w.nm_elemento	:=	'SCHEDULING';
			reg_integracao_w.nr_seq_visao	:=	'';

			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQUENCIA', c01_w.nr_sequencia, 'N', agenda_consulta_w.nr_sequencia) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; agenda_consulta_w.nr_sequencia := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', c01_w.nm_usuario, 'N', agenda_consulta_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; agenda_consulta_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;

			if (reg_integracao_w.qt_reg_log = 0) then
				ie_atualizou_w := reservar_horario_agecons(c01_w.nr_sequencia, c01_w.nm_usuario, ie_atualizou_w);
		end if;

		if (ie_atualizou_w = 'S')	then
			update	intpd_fila_transmissao
			set		ie_status = 'S',
						nr_seq_documento = c01_w.nr_sequencia
			where	nr_sequencia = nr_sequencia_p;
		end if;

		end;

	end loop;
	close c01;
exception
when others then
	begin
		/*'Em caso de qualquer falha o sistema captura a mensagem de erro, efetua o rollback, atualiza o status para Erro e registra a falha ocorrida'*/

		ds_erro_w	:=	substr(sqlerrm,1,4000);

		rollback;

		update	intpd_fila_transmissao
		set		ie_status = 'E',
					ds_log = ds_erro_w
		where	nr_sequencia = nr_sequencia_p;
	end;
end;

if (reg_integracao_w.qt_reg_log > 0) then
	begin
	/*'Em caso de qualquer consistência o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistência'*/

		rollback;

		update	intpd_fila_transmissao
		set		ie_status = 'E',
					ds_log = ds_erro_w
		where	nr_sequencia = nr_sequencia_p;

		for i in 0..reg_integracao_w.qt_reg_log-1 loop
			intpd_gravar_log_recebimento(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
		end loop;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_bloqueia_horario ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;

