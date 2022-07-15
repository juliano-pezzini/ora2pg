-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_pessoa_documentacao () AS $body$
DECLARE


c01 CURSOR FOR
	SELECT	ie_abrangencia,
		ie_exclusao_imagem,
		ie_inativacao,
		nr_seq_tipo_documento,
		qt_dias_exclusao,
		ie_venc_cart_convenio,
		coalesce(ie_exclui_autoatend,'N') ie_exclui_autoatend
	from	regra_exclusao_pessoa_doc
	where	ie_situacao = 'A';

c01_w	c01%rowtype;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pessoa_documentacao
	where	nr_seq_documento = c01_w.nr_seq_tipo_documento
	and		dt_atualizacao_nrec + c01_w.qt_dias_exclusao < clock_timestamp();

c02_w		c02%rowtype;
qt_registro_w	bigint;


BEGIN

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open c02;
	loop
	fetch c02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select	count(1)
		into STRICT	qt_registro_w
		from	pessoa_titular_convenio
		where	trunc(dt_validade_carteira) >= trunc(clock_timestamp())
		and	nr_seq_pessoa_doc = c02_w.nr_sequencia;

		if	((qt_registro_w = 0) or ('N' = c01_w.ie_venc_cart_convenio)) then
			begin

			if ('S' = c01_w.ie_exclui_autoatend) then
			begin
				update	pessoa_doc_foto
				set		ie_apresentar_autoatend = 'N'
				where	nr_seq_pessoa_doc = c02_w.nr_sequencia;
			end;
			end if;

			if ('S' = c01_w.ie_inativacao) then
				begin
				update	pessoa_documentacao
				set	ie_situacao = 'I'
				where	nr_sequencia = c02_w.nr_sequencia;

				delete from pessoa_titular_convenio
				where nr_seq_pessoa_doc = c02_w.nr_sequencia;

				end;
			end if;

			if ('S' = c01_w.ie_exclusao_imagem) then
				begin

				if (c01_w.ie_abrangencia in ('A','B')) then
					begin

					delete
					from	pessoa_fisica_arquivo
					where	nr_seq_documentacao = c02_w.nr_sequencia;

					end;
				end if;

				if (c01_w.ie_abrangencia in ('A','D')) then
					begin

					delete
					from	pessoa_doc_foto
					where	nr_seq_pessoa_doc = c02_w.nr_sequencia;

					end;
				end if;
				end;
			end if;
			end;
		end if;

		end;
	end loop;
	close c02;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_pessoa_documentacao () FROM PUBLIC;

