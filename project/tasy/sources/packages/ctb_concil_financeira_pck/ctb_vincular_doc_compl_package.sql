-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_concil_financeira_pck.ctb_vincular_doc_compl ( nr_documento_p ctb_documento.nr_documento%type, nr_seq_doc_compl_p ctb_documento.nr_seq_doc_compl%type, nr_lote_contabil_p ctb_documento.nr_lote_contabil%type, nm_usuario_p ctb_documento.nm_usuario%type) AS $body$
DECLARE


nr_seq_ctb_documento_w	ctb_documento.nr_sequencia%type;
vl_total_debito_w	ctb_documento.vl_movimento%type;
vl_total_credito_w	ctb_documento.vl_movimento%type;
vl_movimento_doc_w	ctb_documento.vl_movimento%type:= 0;
						
c01 CURSOR FOR
	SELECT	a.nr_seq_info,
		a.nr_seq_doc_compl,
		sum(a.vl_movimento) vl_movimento,
		a.nm_tabela,
		a.nm_atributo,
		b.ie_debito_credito,
		c.cd_tipo_lote_contabil,
		b.cd_estabelecimento,
		b.dt_movimento dt_competencia,
		a.nr_documento
	from	movimento_contabil_doc a,
		movimento_contabil b,
		lote_contabil c
	where	a.nr_lote_contabil	= b.nr_lote_contabil
	and	a.nr_seq_movimento	= b.nr_sequencia
	and 	a.nr_lote_contabil	= c.nr_lote_contabil
	and 	a.nr_documento		= nr_documento_p
	and 	a.nr_lote_contabil	= nr_lote_contabil_p
	group by 	a.nr_documento,
			a.nr_seq_info,
			a.nr_seq_doc_compl,
			b.ie_debito_credito,
			a.nm_tabela,
			a.nm_atributo,
			c.cd_tipo_lote_contabil,
			b.cd_estabelecimento,
			b.dt_movimento
	order by	a.nm_tabela,
			a.nm_atributo,
			b.ie_debito_credito,
			b.cd_estabelecimento;

c01_w		c01%rowtype;	

c02 CURSOR(	nr_seq_info_p		movimento_contabil_doc.nr_seq_info%type,
                nr_seq_doc_compl_p	movimento_contabil_doc.nr_seq_doc_compl%type,
                nm_tabela_p		movimento_contabil_doc.nm_tabela%type,
                nm_atributo_p		movimento_contabil_doc.nm_atributo%type,
                ie_debito_credito_p	movimento_contabil.ie_debito_credito%type,
                cd_tipo_lote_contabil_p	lote_contabil.cd_tipo_lote_contabil%type,
                cd_estabelecimento_p	movimento_contabil.cd_estabelecimento%type,
                dt_competencia_p	movimento_contabil.dt_movimento%type)FOR
	SELECT	a.nr_seq_info,
		a.nr_seq_doc_compl,
		a.vl_movimento,
		c.cd_tipo_lote_contabil,
		b.dt_movimento dt_competencia,
		a.nm_tabela,
		a.nm_atributo,
		b.cd_estabelecimento,
		b.ie_debito_credito,
		a.nr_sequencia,
		a.nr_doc_analitico
	from	movimento_contabil_doc a,
		movimento_contabil b,
		lote_contabil c
	where	a.nr_lote_contabil	=	b.nr_lote_contabil
	and	a.nr_seq_movimento	=	b.nr_sequencia
	and 	a.nr_lote_contabil	=	c.nr_lote_contabil
	and 	a.nr_documento		=	nr_documento_p
	and 	a.nr_lote_contabil	=	nr_lote_contabil_p
	and 	a.nr_seq_info		=	nr_seq_info_p
	and	a.nr_seq_doc_compl	=       nr_seq_doc_compl_p
	and	a.nm_tabela		=       nm_tabela_p
	and	a.nm_atributo		=       nm_atributo_p
	and	b.ie_debito_credito	=       ie_debito_credito_p
	and	c.cd_tipo_lote_contabil	=       cd_tipo_lote_contabil_p
	and	b.cd_estabelecimento	=       cd_estabelecimento_p
	and	b.dt_movimento		=       dt_competencia_p
	order by	a.nm_tabela,
			a.nm_atributo,
			b.ie_debito_credito,
			b.cd_estabelecimento;

c02_w		c02%rowtype;					
BEGIN

open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count + 1).cd_tipo_lote_contabil	:= c01_w.cd_tipo_lote_contabil;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).nr_seq_doc_compl		:= c01_w.nr_seq_doc_compl;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).nm_tabela			:= c01_w.nm_tabela;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).nm_atributo			:= c01_w.nm_atributo;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).ie_debito_credito		:= c01_w.ie_debito_credito;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).vl_movimento			:= c01_w.vl_movimento;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).cd_estabelecimento		:= c01_w.cd_estabelecimento;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).dt_competencia			:= c01_w.dt_competencia;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).nr_seq_info			:= c01_w.nr_seq_info;
	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos(current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.count).ie_update			:= 'N';
	
	if (c01_w.ie_debito_credito = 'D') and (coalesce(c01_w.vl_movimento, 0) <> 0)	then
		begin
		vl_total_debito_w	:= vl_total_debito_w + c01_w.vl_movimento;	
		end;
	elsif (c01_w.ie_debito_credito = 'C') and (coalesce(c01_w.vl_movimento, 0) <> 0)	then
		begin
		vl_total_credito_w	:= vl_total_credito_w + c01_w.vl_movimento;
		end;
	end if;
	
	end;
end loop;
close c01;

if (coalesce(vl_total_credito_w, 0) = coalesce(vl_total_debito_w,0)) then
	begin
	
	for idx in 1..array_regitros_w.count loop
		begin
				
		if (current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].ie_update = 'N') then
			begin
			
			for idx_w in 1..array_regitros_w.count loop
				begin
				
				if (current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].nr_seq_doc_compl = current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx_w].nr_seq_doc_compl) then
					begin

					current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx_w].ie_update := 'S';
					
					end;
				else
					begin
					if (current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].ie_update = 'N') then
						begin
						current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx_w].ie_update := 'N';
						end;
					end if;
					
					end;
				end if;
								
				end;
			end loop;
			
			end;
		end if;

		open c02(	current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].nr_seq_info,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].nr_seq_doc_compl,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].nm_tabela,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].nm_atributo,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].ie_debito_credito,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].cd_tipo_lote_contabil,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].cd_estabelecimento,
				current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos[idx].dt_competencia			
		);
		loop
		fetch c02 into	
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			begin
			
			select	a.nr_sequencia,
				a.vl_movimento
			into STRICT	nr_seq_ctb_documento_w,
				vl_movimento_doc_w
			from	ctb_documento a
			where	a.cd_estabelecimento		=	c02_w.cd_estabelecimento
			and 	a.dt_competencia		=	c02_w.dt_competencia
			and 	a.cd_tipo_lote_contabil		=	c02_w.cd_tipo_lote_contabil
			and 	a.nr_seq_info			=	c02_w.nr_seq_info
			and 	a.nr_documento			=	nr_documento_p
			and 	coalesce(a.nr_seq_doc_compl,0)	=	coalesce(c02_w.nr_seq_doc_compl,0)
			and 	a.nm_tabela			=	c02_w.nm_tabela
			and 	a.nm_atributo			=	c02_w.nm_atributo
			and 	a.vl_movimento			=	c02_w.vl_movimento
			and	ie_status			<>	'C'  LIMIT 1;

			exception
			when others then
				nr_seq_ctb_documento_w	:= 0;
			end;
			
			if (nr_seq_ctb_documento_w <> 0) then
				begin
				
				update	movimento_contabil_doc
				set	nr_seq_ctb_documento	=	nr_seq_ctb_documento_w,
					nm_usuario		=	nm_usuario_p,
					dt_atualizacao		=	clock_timestamp()
				where	nr_sequencia		=	c02_w.nr_sequencia;
				
				update	ctb_documento
				set	nr_lote_contabil	=	nr_lote_contabil_p,
					ie_status		=	'C',
					nm_usuario		=	nm_usuario_p,
					dt_atualizacao		=	clock_timestamp()
				where	nr_sequencia		=	nr_seq_ctb_documento_w;
				
				end;
			end if;
			
			end;
		end loop;
		close c02;
			
		end;
	end loop;
	
	end;
end if;

current_setting('ctb_concil_financeira_pck.array_regitros_w')::campos.delete;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_concil_financeira_pck.ctb_vincular_doc_compl ( nr_documento_p ctb_documento.nr_documento%type, nr_seq_doc_compl_p ctb_documento.nr_seq_doc_compl%type, nr_lote_contabil_p ctb_documento.nr_lote_contabil%type, nm_usuario_p ctb_documento.nm_usuario%type) FROM PUBLIC;